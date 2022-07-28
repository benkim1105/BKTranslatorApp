//
//  HeaderCollectionReusableView.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/07/12.
//

import UIKit
import SnapKit

class HeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "HeaderCollectionReusableView"

    let headerView: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = .systemFont(ofSize: 20, weight: .semibold)
        return view
    }()

    func configure(with header: String) {
        headerView.text = header
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(headerView)
        
        headerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(5)
            make.height.equalTo(20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        headerView.text = nil
    }
}
