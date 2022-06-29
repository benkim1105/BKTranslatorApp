//
//  LightButton.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/06/27.
//

import UIKit

class LightButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemGray5
        self.setTitleColor(.label, for: .normal)
        self.layer.cornerRadius = 22.5
        self.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

}
