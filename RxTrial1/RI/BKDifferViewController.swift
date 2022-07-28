//
//  BKDifferViewController.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/07/16.
//

import UIKit
import SnapKit

class BKDifferViewController: UIViewController {
    let diffTextView: DiffTextView = {
        let view = DiffTextView()
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(diffTextView)
        
        diffTextView.snp.makeConstraints { make in
            make.leading.trailing.topMargin.equalToSuperview().inset(15)
            make.height.equalTo(100)
        }
        
        diffTextView.showDiff(srcText: "nice job!", targetText: "good job!")
    }
    
}
