//
//  BKSaveViewController.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/06/29.
//

import UIKit

class BKSaveViewController: UIViewController {
    let viewModel: BKSaveViewModelProtocol
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        UIImagePickerController()
    }
    
    

    //MARK: - init
    
    init(viewModel: BKSaveViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
