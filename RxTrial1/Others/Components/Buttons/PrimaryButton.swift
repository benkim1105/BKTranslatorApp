//
//  PrimaryButton.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/06/27.
//

import UIKit

class PrimaryButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemBlue
        self.setTitleColor(.white, for: .normal)
        self.layer.cornerRadius = 22.5
        self.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
