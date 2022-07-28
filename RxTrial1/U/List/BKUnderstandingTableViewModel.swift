//
//  BKUnderstandingTableView.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/07/13.
//

import Foundation
import RxSwift

protocol BKUnderstandingTableViewModelProtocol: AnyObject {
    func viewDidLoad()
}

protocol BKUnderstandingTableView: BKView {
    var viewModel: BKUnderstandingTableViewModelProtocol { get set }
    var sentences: BehaviorSubject<[BKSentence]> { get set }
}

protocol BKUnderstandingTableModelProtocol {
    func fetchData() -> Observable<[BKSentence]>
}

class BKUnderstandingTableViewModel: BKUnderstandingTableViewModelProtocol {
    private weak var view: BKUnderstandingTableView?
    let model: BKUnderstandingTableModelProtocol
    var disposeBag = DisposeBag()
    
    init (model: BKUnderstandingTableModel) {
        self.model = model
    }
    
    func viewDidLoad() {
        model.fetchData()
            .subscribe { [weak self] sentences in
                self?.view?.sentences.onNext(sentences)
            } onError: { [weak self] error in
                self?.view?.complain("Fail to fetch data.")
            }
            .disposed(by: disposeBag)
    }
}

class BKUnderstandingTableModel: BKUnderstandingTableModelProtocol {
    let dataService: BKDataServiceProtocol
    
    init (dataService: BKDataServiceProtocol) {
        self.dataService = dataService
    }
    
    func fetchData() -> Observable<[BKSentence]> {
        return dataService.getList(type: .USentence, startToken: nil, count: 99, order: nil)
            .flatMap { [weak self] (listResult: ListResult<String>) -> Observable<[BKSentence]> in
                guard let self = self else {
                    return Observable.just([])
                }
                
                return self.dataService.getList(type: .Sentence, idList: listResult.items)
                    .map { (listResult: ListResult<BKSentence>) -> [BKSentence] in
                        return listResult.items
                    }
            }
    }
}
