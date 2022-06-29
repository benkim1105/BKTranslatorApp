//
//  BKSaveViewModel.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/06/29.
//

import Foundation

protocol BKSaveViewModelProtocol {
    
}

class BKSaveViewModel: BKSaveViewModelProtocol {
    let sentences: [Sentence]
    
    init(sentences: [Sentence]) {
        self.sentences = sentences
    }
    
}
