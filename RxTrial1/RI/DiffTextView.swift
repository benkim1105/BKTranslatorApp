//
//  DiffTextView.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/07/16.
//

import UIKit
import RxSwift

class DiffTextView: UITextView, DiffTextViewProtocol {
    var viewModel: DiffTextViewModelProtocol
    var diffString: BehaviorSubject<NSAttributedString> = BehaviorSubject(value: NSAttributedString())
    var disposeBag = DisposeBag()

    func showDiff(srcText: String, targetText: String) {
        viewModel.showDiffString(srcText: srcText, targetText: targetText)
    }
    
    init (viewModel: DiffTextViewModelProtocol = DiffTextViewModel()) {
        self.viewModel = viewModel
        super.init(frame: .zero, textContainer: nil)
        self.viewModel.view = self
        
        diffString
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { value in
                self.attributedText = value
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
