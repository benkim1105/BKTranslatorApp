//
//  TextFieldCell.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/06/29.
//

import UIKit
import SnapKit

class TextFieldCell: UITableViewCell {
    static let identifier = "TextFieldCell"
    
    let textField: UITextField = {
        let view = UITextField(frame: .zero)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
