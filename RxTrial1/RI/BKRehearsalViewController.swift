//
//  RehearsalViewController.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/07/15.
//

import UIKit
import Speech
import RxCocoa
import RxSwift
import SnapKit

class BKRehearsalViewController: UIViewController {
    private var audioEngine: AVAudioEngine?
    private var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private var recording = BehaviorSubject<Bool>(value: false)
    private var disposeBag = DisposeBag()
    
    var recognizeButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setTitle("Press me", for: .normal)
        view.setTitleColor(.label, for: .normal)
        return view
    }()
    
    var textView: UITextView = {
        let view = UITextView(frame: .zero)
        view.font = .systemFont(ofSize: 18)
        
        return view
    }()
    
    var textViewPlaceHolder: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 18)
        view.text = "Press start and say anything."
        view.textColor = .gray
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkAuth()
        audioEngine = AVAudioEngine()
        speechRecognizer = SFSpeechRecognizer()
        
        configUI()
        bindUI()
    }

    private func startRecognition() {
        guard let audioEngine = audioEngine, let speechRecognizer = speechRecognizer else {
            return
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object") }
        recognitionRequest.shouldReportPartialResults = true
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .voicePrompt, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            complain(message: "Fail to start audio. Please try again.")
            return
        }
        
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            var isFinal = false
            
            if let result = result {
                // Update the text view with the results.
                self?.textView.text = result.bestTranscription.formattedString
                isFinal = result.isFinal
                print("Text \(result.bestTranscription.formattedString)")
            }
            
            if error != nil || isFinal {
                // Stop recognizing speech if there is a problem.
                self?.audioEngine?.stop()
                inputNode.removeTap(onBus: 0)

                self?.recognitionRequest = nil
                self?.recognitionTask = nil
                self?.recording.onNext(false)
                
                print("finished")
            }
        }
        
        do {
            try audioEngine.start()
        } catch {
            complain(message: "Fail to start audio2. Please try again.")
        }
    }
    
    private func stopRecognition() {
        recognitionTask?.cancel()
    }
    
    func bindUI() {
        recognizeButton.rx.tap.subscribe(onNext: { _ in
            try? self.recording.onNext(!(self.recording.value()))
        })
        .disposed(by: disposeBag)
        
        recording.subscribe(onNext: { [weak self] recording in
            if recording {
                self?.recognizeButton.setTitle("Stop", for: .normal)
                self?.startRecognition()
            } else {
                self?.recognizeButton.setTitle("Start", for: .normal)
                self?.stopRecognition()
            }
        })
        .disposed(by: disposeBag)
        
        textView.rx.text.subscribe(onNext: { value in
            self.textViewPlaceHolder.isHidden = !(value?.isEmpty ?? false)
        })
        .disposed(by: disposeBag)
    }
    
    func configUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(recognizeButton)
        view.addSubview(textView)
        textView.addSubview(textViewPlaceHolder)
        
        recognizeButton.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(45)
            make.centerX.equalToSuperview()
            make.bottomMargin.equalToSuperview().inset(50)
        }
        textView.snp.makeConstraints { make in
            make.topMargin.leading.trailing.equalToSuperview().inset(15)
            make.bottom.equalTo(recognizeButton.snp.top).inset(10)
        }
        textViewPlaceHolder.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview().inset(10)
            make.height.equalTo(20)
        }
    }
    
    fileprivate func checkAuth() {
        SFSpeechRecognizer.requestAuthorization { status in
            switch status {
            case .notDetermined:
                self.confirm(message: "Speech recognition not yet authorized") {
                    self.dismiss(animated: true)
                }
            case .denied:
                self.confirm(message: "User denied access to speech recognition") {
                    self.dismiss(animated: true)
                }
            case .restricted:
                self.confirm(message: "Speech recognition restricted on this device") {
                    self.dismiss(animated: true)
                }
            case .authorized:
                break
                
            @unknown default:
                fatalError()
            }
        }
    }
}
