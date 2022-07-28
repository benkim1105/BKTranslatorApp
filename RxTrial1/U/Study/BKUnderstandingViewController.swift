//
//  BKUnderstandingViewController.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/07/14.
//

import UIKit

class BKUnderstandingViewController: UIViewController, BKUnderstandingViewProtocol {
    var viewModel: BKUnderstandingViewModelProtocol
    
    init (viewModel: BKUnderstandingViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
    }
    
    
}
