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
    func onSaveCompletion()
}

protocol BKSaveViewModelProtocol {
    var view: BKSaveViewProtocol? { get set }
    func save(title: String, image:UIImage?)
}

protocol BKSaveModelProtocol: AnyObject {
    typealias ServerId = String
    
    ///tts 다운받고, 파일로 저장한 후 url 반환
    func makeTTS(with sentences: [BKSentence]) -> Observable<[URL?]>
    
    ///book 저장
    func saveEpisode(id: String, title: String, image: String?) -> Observable<ServerId>

    ///sentences 저장
    func saveSentences(_ sentences: [BKSentence]) -> Observable<[ServerId]>
    
    ///book cover 저장
    func saveImage(image: UIImage?, name: String?) -> Observable<RemoteImage?>
}

class BKSaveViewModel: BKSaveViewModelProtocol {
    let disposeBag = DisposeBag()
    let sentences: [BKSentence]
    let model: BKSaveModelProtocol
    weak var view: BKSaveViewProtocol?
    
    
    init(sentences: [BKSentence], model: BKSaveModelProtocol) {
        self.sentences = sentences
        self.model = model
    }

    func save(title: String, image: UIImage?) {
        view?.showProgress.accept(true)
        
        var sentences = self.sentences
        let bookId = UUID().uuidString
        sentences = sentences.map {
            BKSentence(
                id: $0.id,
                bookId: bookId,
                sentence: $0.sentence,
                translation: $0.translation,
                sentenceLanguage: $0.sentenceLanguage,
                translationLanguage: $0.translationLanguage)
        }
        
        let imageName = image != nil ? "\(bookId).jpg" : nil
        let bookObserver = model.saveEpisode(id: bookId, title: title, image: imageName)
        let sentencesObserver = model.saveSentences(sentences)
        let ttsObserver = model.makeTTS(with: sentences)
        let imageObserver = model.saveImage(image: image, name: imageName)
        
        Observable.zip(bookObserver, sentencesObserver, ttsObserver, imageObserver)
            .subscribe { [weak self] (book, sentences, urls, image) in
                self?.view?.showProgress.accept(false)
                self?.view?.onSaveCompletion()
            } onError: { [weak self] error in
                print(error)
                self?.view?.showProgress.accept(false)
                self?.view?.showError.accept("저장에 실패하였습니다. 다시 시도해주세요.")
            }
            .disposed(by: disposeBag)
    }
}

class BKSaveModel: BKSaveModelProtocol {
    let api: TranslatorAPIProtocol
    let localFileService: BKLocalFileServiceProtocol
    let dataService: BKDataServiceProtocol
    let remoteFileService: BKRemoteFileServiceProtocol
    
    init(api: TranslatorAPIProtocol,
         localFileService: BKLocalFileServiceProtocol,
         dataService: BKDataServiceProtocol,
         remoteFileService: BKRemoteFileServiceProtocol)
    {
        self.api = api
        self.localFileService = localFileService
        self.dataService = dataService
        self.remoteFileService = remoteFileService
    }
    
    func makeTTS(with sentences: [BKSentence]) -> Observable<[URL?]> {
        guard let language = sentences.first?.sentenceLanguage, let voiceName = VoiceName.voiceNames(language: language).randomElement() else {
            return Observable.error(APIError.invalidParameter)
        }

        //FIXME: 너무 많으면 요청을 나누거나, 요청 개수 자체를 제한하거나.

        return Observable.zip(sentences.map ({ sentence in
            api.tts(
                id: sentence.id ?? "0",
                text: sentence.sentence,
                language: sentence.sentenceLanguage,
                voiceName: voiceName
            )
            .map { data -> URL? in
                //save file (32k mp3)
                let fileURL = self.localFileService.saveFile(type: .mp3, data: data, name:"\(sentence.id!).mp3")
                return fileURL
            }
        }))
    }

    func saveEpisode(id: String, title: String, image: String?) -> Observable<ServerId> {
        let book = BKEpisode(id: id, serverId: nil, title: title, image: image)
        return dataService.save(book, type: .Episode)
    }
    
    func saveSentences(_ sentences: [BKSentence]) -> Observable<[ServerId]> {
        return dataService.saveList(sentences, type: .Sentence)
    }

    func saveImage(image: UIImage?, name: String?) -> Observable<RemoteImage?> {
        if let name = name, let image = image {
            return remoteFileService.saveImageFile(image: image, name: name, quality: 0.7)
        } else {
            return Observable.just(nil)
        }
    }
    
}
