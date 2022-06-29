//
//  ScriptTranslationEditorView.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/06/27.
//

import UIKit
import SnapKit

struct ScriptTranslationEditorViewModel {
    let script: String
    let translation: String
}

class ScriptTranslationEditorView: UIView {
    func configure(with viewModel: ScriptTranslationEditorViewModel) {
        scriptView.text = viewModel.script
        translationView.text = viewModel.translation
    }
    
    var scriptView: UITextView = {
        let view = UITextView()
        view.backgroundColor = .systemBackground
        view.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        view.font = .systemFont(ofSize: 18)
        return view
    }()
    
    var translationView: UITextView = {
        let view = UITextView()
        view.backgroundColor = .systemBackground
        view.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        view.font = .systemFont(ofSize: 18)
        return view
    }()
    
    var buttonConfirm: PrimaryButton = {
        let view = PrimaryButton(frame: .zero)
        view.setTitle("Save", for: .normal)
        return view
    }()
    
    var buttonCancel: LightButton = {
        let view = LightButton(frame: .zero)
        view.setTitle("Cancel", for: .normal)
        return view
    }()
    
    lazy var actionStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [buttonCancel, buttonConfirm])
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .fill
        view.spacing = 10
        return view
    }()
    
    lazy var vstack: UIStackView = {
        let scriptStack = UIStackView(arrangedSubviews: [scriptView, translationView])
        scriptStack.axis = .vertical
        scriptStack.distribution = .fillEqually
        scriptStack.spacing = 1
        scriptStack.backgroundColor = .secondarySystemBackground
        scriptStack.layer.cornerRadius = 22.5
        scriptStack.layer.masksToBounds = true
        
        let view = UIStackView(arrangedSubviews: [scriptStack, actionStack])
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 10
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .secondarySystemBackground
        self.addSubview(vstack)
        
        actionStack.snp.makeConstraints { make in
            make.height.equalTo(45).priority(.required)
        }
        
        vstack.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}
