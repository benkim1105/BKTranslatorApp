//
//  DiffTextViewModel.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/07/16.
//

import Foundation
import RxSwift
import UIKit

protocol DiffTextViewModelProtocol {
    var view: DiffTextViewProtocol? { get set }
    func showDiffString(srcText: String, targetText: String)
}

protocol DiffTextViewProtocol: AnyObject {
    var viewModel: DiffTextViewModelProtocol { get set }
    var diffString: BehaviorSubject<NSAttributedString> { get set }
}

class DiffTextViewModel: DiffTextViewModelProtocol {
    weak var view: DiffTextViewProtocol?
    
    func showDiffString(srcText: String, targetText: String) {
        let differences = srcText.difference(from: targetText)
        
        let string = NSMutableAttributedString(string: targetText, attributes: [.foregroundColor: UIColor.systemGreen])
        differences.forEach({ change in
            if case .remove(let offset, _, _) = change {
                string.addAttributes([.foregroundColor : UIColor.systemRed], range: NSRange(location: offset, length: 1))
            }
        })
        
        view?.diffString.onNext(string)
    }
}
