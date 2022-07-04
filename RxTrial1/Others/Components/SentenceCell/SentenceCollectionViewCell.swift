//
//  SentenceCollectionViewCell.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/07/04.
//

import UIKit
import SnapKit

class SentenceCollectionViewCell: UICollectionViewCell {
    static let identifier = "SentenceCollectionViewCell"
    
    var textView: UILabel = {
        let view = UILabel(frame: .zero)
        view.numberOfLines = 0
        view.textAlignment = .left
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        
        self.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview().inset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
