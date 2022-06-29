//
//  TranslatorViewModel.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/06/27.
//

import Foundation
import RxSwift
import RxRelay

protocol BKNewViewProtocol: AnyObject {
    var showProgress: PublishSubject<Bool> { get }
    var showErrorMessage: PublishSubject<String> { get }
}

protocol BKNewViewModelProtocol {
    var view: BKNewViewProtocol? { get set }
    var searchResults: BehaviorRelay<[HeaderTitleSubtitleCellViewModel]> { get }
    var savedSentences: BehaviorRelay<[Sentence]> { get }
    var searchText: String? { get set }
    func search(text: String)
}

class BKNewViewModel: BKNewViewModelProtocol {
    weak var view: BKNewViewProtocol?
    let model: TranslatorServiceProtocol
    let disposeBag = DisposeBag()
    
    var searchText: String? = nil
    var searchResults: BehaviorRelay<[HeaderTitleSubtitleCellViewModel]> = BehaviorRelay(value: [])
    var savedSentences: BehaviorRelay<[Sentence]> = BehaviorRelay(value: [])
    
    
    init(model: TranslatorServiceProtocol) {
        self.model = model
    }
    
    func search(text: String) {
        searchText = text
        searchResults.accept([])
        view?.showProgress.onNext(true)
        model.searchTranslationAll(text: text)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] result in
                guard var value = self?.searchResults.value else {
                    return
                }
                
                value.append(HeaderTitleSubtitleCellViewModel(
                    header: result.engine?.name ?? "",
                    title: result.translation.translation ?? "",
                    subtitle: result.metaTranslation.translation ?? ""
                ))
                
                self?.searchResults.accept(value)
            } onError: { [weak self] error in
                self?.view?.showErrorMessage.onNext("검색 결과를 가져오지 못했습니다.")
            } onCompleted: { [weak self] in
                self?.view?.showProgress.onNext(false)
            }
            .disposed(by: disposeBag)
    }
}

