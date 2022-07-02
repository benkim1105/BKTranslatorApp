//
//  BKSaveViewModel.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/06/29.
//

import Foundation
import SwiftUI
import RxSwift
import RxRelay


protocol BKSaveViewProtocol: AnyObject {
    var showProgress: BehaviorRelay<Bool> { get }
    var showError: PublishRelay<String> { get }
    func playTemp(url: URL?)
}

protocol BKSaveViewModelProtocol {
    var view: BKSaveViewProtocol? { get set }
    func save(title: String, image:UIImage?)
}

protocol BKSaveModelProtocol: AnyObject {
    ///tts 를 다운받고, 파일로 저장한 후 url 을 반환한다.
    func makeTTS(with sentences: [Sentence]) -> Observable<[URL]>
}

class BKSaveViewModel: BKSaveViewModelProtocol {
    let disposeBag = DisposeBag()
    let sentences: [Sentence]
    let model: BKSaveModelProtocol
    weak var view: BKSaveViewProtocol?
    
    
    init(sentences: [Sentence], model: BKSaveModelProtocol) {
        self.sentences = sentences
        self.model = model
    }

    func save(title: String, image: UIImage?) {
        view?.showProgress.accept(true)
        
        model.makeTTS(with: sentences)
            .subscribe { [weak self] response in
                print(response)
                self?.view?.playTemp(url: response.first)

            } onError: { [weak self] error in
                print(error)
                self?.view?.showError.accept("음성 데이터를 가져오는데 실패하였습니다. 다시 시도해주세요.")
            }
            .disposed(by: disposeBag)
    }
}

class BKSaveModel: BKSaveModelProtocol {
    let api: APIProtocol
    
    init(api: APIProtocol) {
        self.api = api
    }
    
    func makeTTS(with sentences: [Sentence]) -> Observable<[URL]> {
        guard let language = sentences.first?.scriptLanguage, let voiceName = VoiceName.voiceNames(language: language).randomElement() else {
            return Observable.error(APIError.invalidParameter)
        }

        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let mp3Directory = documentDirectory.appendingPathComponent("mp3")
        if !fileManager.fileExists(atPath: mp3Directory.path) {
            do {
                try fileManager.createDirectory(at: mp3Directory, withIntermediateDirectories: true)
            } catch {
                return Observable.error(APIError.internalError)
            }
        }

        //FIXME: 너무 많으면 요청을 나누거나, 요청 개수 자체를 제한하거나.
        
        return Observable.zip(sentences.map ({ sentence in
            api.tts(
                id: sentence.id ?? "0",
                text: sentence.script,
                language: sentence.scriptLanguage,
                voiceName: voiceName
            )
            .map { data in
                //save file (32k mp3)
                let filePath = mp3Directory.appendingPathComponent("\(sentence.id ?? "0").mp3")
                if fileManager.fileExists(atPath: filePath.path) {
                    try? fileManager.removeItem(atPath: filePath.path)
                }
                fileManager.createFile(atPath: filePath.path, contents: data)
                return filePath
            }
        }))
    }
}
