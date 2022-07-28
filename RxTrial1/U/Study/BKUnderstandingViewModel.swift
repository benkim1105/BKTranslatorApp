//
//  BKUnderstandingViewModel.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/07/14.
//
//  문장 분해하기
//

import Foundation

protocol BKUnderstandingViewProtocol: AnyObject {
    var viewModel: BKUnderstandingViewModelProtocol { get set }
}

protocol BKUnderstandingViewModelProtocol: AnyObject {
    var view: BKUnderstandingViewProtocol? { get set }
}

protocol BKUnderstandingModelProtocol {
    
}

class BKUnderstandingViewModel: BKUnderstandingViewModelProtocol {
    weak var view: BKUnderstandingViewProtocol?
    let model: BKUnderstandingModelProtocol
    
    init (model: BKUnderstandingModelProtocol) {
        self.model = model
    }
}


