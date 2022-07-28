//
//  VerticalImageTextCell.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/07/05.
//

import UIKit
import SnapKit
import SDWebImage

struct VerticalImageTextCellModel {
    var imageUrl: String?
    var title: String?
}

class VerticalImageTextCell: UICollectionViewCell {
    static let identifier = "VerticalImageTextCell"
    
    func configure(with viewModel: VerticalImageTextCellModel) {
        self.imageView.sd_setImage(with: URL(string: viewModel.imageUrl ?? ""))
        self.textView.text = viewModel.title
    }
    
    let imageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.backgroundColor = .systemBlue
        return view
    }()
    
    let textView: UILabel = {
        let view = UILabel(frame: .zero)
        view.numberOfLines = 1
        view.backgroundColor = .systemRed
        return view
    }()

    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [imageView, textView])
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 0
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        textView.snp.makeConstraints { make in
            make.height.equalTo(40).priority(.required)
        }
        
        imageView.snp.makeConstraints { make in
            make.height.equalTo(100).priority(.low)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
