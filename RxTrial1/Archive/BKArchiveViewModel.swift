//
//  BKArchiveViewModel.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/07/06.
//

import Foundation
import RxSwift

protocol BKArchiveViewModelProtocol: AnyObject {
    func viewDidLoad()
}

protocol BKArchiveViewProtocol: AnyObject {
    var episodes: BehaviorSubject<[BKEpisode]> { get set }
    var sentences: BehaviorSubject<[BKSentence]> { get set }
    
    func showError(_ message: String)
}

protocol BKArchiveModelProtocol {
    func episodeList(count: Int) -> Observable<[BKEpisode]>
    func sentences(count: Int) -> Observable<[BKSentence]>
}

class BKArchiveViewModel: BKArchiveViewModelProtocol {
    let disposeBag = DisposeBag()
    let model: BKArchiveModelProtocol
    weak var view: BKArchiveViewProtocol?
    
    init(model: BKArchiveModelProtocol) {
        self.model = model
    }
    
    func viewDidLoad() {
        let episodesObservable = model.episodeList(count: 10)
        let sentencesObservable = model.sentences(count: 30)
        
        Observable.zip(episodesObservable, sentencesObservable)
            .subscribe { [weak self] (episodes, sentences) in
                self?.view?.episodes.onNext(episodes)
                self?.view?.sentences.onNext(sentences)
            } onError: { [weak self] error in
                self?.view?.showError("Fail to load data.")
            } onCompleted: {
            }
            .disposed(by: disposeBag)

    }
}

class BKArchivewModel: BKArchiveModelProtocol {
    let dataService: BKDataServiceProtocol
    
    init (dataService: BKDataServiceProtocol) {
        self.dataService = dataService
    }
    
    func episodeList(count: Int) -> Observable<[BKEpisode]> {
        return dataService.getList(type: .Episode, startToken: nil, count: count, order: [("timestamp", .desc)])
            .map { $0.items }
    }
    
    func sentences(count: Int) -> Observable<[BKSentence]> {
        return dataService.getList(type: .Sentence, startToken: nil, count: count, order: [("timestamp", .desc)])
            .map { $0.items }
    }
}
