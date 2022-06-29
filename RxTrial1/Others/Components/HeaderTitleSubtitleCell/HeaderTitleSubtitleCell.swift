//
//  TranslationTableViewCell.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/06/27.
//

import UIKit
import SnapKit

class HeaderTitleSubtitleCell: UITableViewCell {
    static let identifier = "HeaderTitleSubtitleCell"
    
    var header: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14, weight: .thin)
        return view
    }()
    
    var title: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = .systemFont(ofSize: 18, weight: .regular)
        return view
    }()
    
    var subtitle: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = .systemFont(ofSize: 16)
        view.textColor = .gray
        return view
    }()

    lazy var stack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [header, title, subtitle])
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .fill
        view.spacing = 10
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(stack)
        
        stack.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview().inset(15)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with viewModel: HeaderTitleSubtitleCellViewModel) {
        header.text = viewModel.header
        title.text = viewModel.title
        subtitle.text = viewModel.subtitle
    }

}
