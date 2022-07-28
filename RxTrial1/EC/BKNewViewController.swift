//
//  TranslatorViewController.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/06/27.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BKNewViewController: UIViewController, BKNewViewProtocol {
    let disposeBag = DisposeBag()
    var viewModel: BKNewViewModelProtocol
    
    var showErrorMessage: PublishSubject<String> = PublishSubject()
    var showProgress: PublishSubject<Bool> = PublishSubject()
    var tempTranslation: BehaviorRelay<Translation?> = BehaviorRelay(value: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let todo = "savedSentences 수정, 삭제"
        
        configUI()
        viewModel.view = self
        
        viewModel.searchResults.bind(to: resultTableView.rx.items(cellIdentifier: HeaderTitleSubtitleCell.identifier)) { index, viewModel, cell in
            guard let cell = cell as? HeaderTitleSubtitleCell else {
                return
            }
            cell.configure(with: viewModel)
        }
        .disposed(by: disposeBag)
        
        viewModel.savedSentences.bind(
            to: sentenceTableView.rx.items(cellIdentifier: HeaderTitleSubtitleCell.identifier)
        ) { index, viewModel, cell in
            guard let cell = cell as? HeaderTitleSubtitleCell else {
                return
            }
            
            cell.configure(with: HeaderTitleSubtitleCellViewModel(
                header: "",
                title: viewModel.sentence,
                subtitle: viewModel.translation
            ))
        }
        .disposed(by: disposeBag)
        
        viewModel.searchResults.subscribe(onNext: { results in
            self.noSearchResult.isHidden = !results.isEmpty
        })
        .disposed(by: disposeBag)
        viewModel.savedSentences.subscribe(onNext: { sentences in
            self.saveButton.isEnabled = !sentences.isEmpty
        })
        .disposed(by: disposeBag)
        
        textEditor.rx.text.subscribe(onNext: { value in
            let hasText = (value?.count ?? 0 > 0)
            
            self.searchButton.isEnabled = hasText
            self.searchButton.alpha = hasText ? 1 : 0.5
            self.sentenceTableView.isHidden = hasText
            self.noSearchResult.isHidden = !hasText
        })
        .disposed(by: disposeBag)
        
        searchButton.rx.tap.bind { [weak self] _ in
            self?.view.endEditing(true)
            
            if let text = self?.textEditor.text.trimmingCharacters(in: .whitespaces), text.count > 0 {
                self?.viewModel.search(text: text)
            } else {
                //do nothing
            }
        }.disposed(by: disposeBag)
        
        tempTranslation.subscribe(onNext: { translation in
            if let translation = translation {
                self.translationEditor.isHidden = false
                self.translationEditor.configure(
                    with:ScriptTranslationEditorViewModel(
                        script: translation.text ?? "",
                        translation: translation.translation ?? ""))
            } else {
                self.translationEditor.isHidden = true
            }
        })
        .disposed(by: disposeBag)
        
        resultTableView.rx.itemSelected.bind { [weak self] indexPath in
            self?.resultTableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
            let viewModel = self?.viewModel.searchResults.value[indexPath.row]
            
            self?.tempTranslation.accept(Translation(
                text: self?.viewModel.searchText,
                translation: viewModel?.title
            ))
        }
        .disposed(by: disposeBag)
        
        translationEditor.buttonCancel.rx.tap.bind { _ in
            self.tempTranslation.accept(nil)
        }
        .disposed(by: disposeBag)
        
        translationEditor.buttonConfirm.rx.tap.bind { _ in
            let script = self.translationEditor.scriptView.text.trimmingCharacters(in: .whitespaces)
            let translation = self.translationEditor.translationView.text.trimmingCharacters(in: .whitespaces)
            guard !translation.isEmpty, !script.isEmpty else {
                BKHapticService.shared.warning()
                return
            }
            
            let todo = "여기 language 값을 어디선가 받아야 한다."
            let sentence = BKSentence(sentence: script, translation: translation, sentenceLanguage: .ko, translationLanguage: .en)
            
            self.viewModel.savedSentences.accept(self.viewModel.savedSentences.value + [sentence])
         
            self.tempTranslation.accept(nil)
            self.viewModel.searchText = nil
            self.viewModel.searchResults.accept([])
            self.textEditor.text = ""
        }
        .disposed(by: disposeBag)
        
        saveButton.rx.tap.bind { _ in
            let sentences = self.viewModel.savedSentences.value
            let viewModel = BKFactory.shared.saveViewModel(sentences: sentences)
            let saveVC = BKSaveViewController(viewModel: viewModel)
            self.navigationController?.pushViewController(saveVC, animated: true)
        }
        .disposed(by: disposeBag)
    }
    
    //MARK: init
    init(viewModel: BKNewViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: UI
    var saveButton: UIBarButtonItem = {
        let view = UIBarButtonItem(title: "Save", style: .plain, target: nil, action: nil)
        return view
    }()
    
    var textEditor: UITextView = {
        let view = UITextView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 22.5
        view.layer.masksToBounds = true
        view.font = .systemFont(ofSize: 22, weight: .semibold)
        view.contentInset = UIEdgeInsets(top: 10, left: 15, bottom: 65, right: 15)
        return view
    }()
    
    var translationEditor: ScriptTranslationEditorView = {
        let view = ScriptTranslationEditorView(frame: .zero)
        
        return view
    }()
    
    var searchButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .systemBlue
        view.setTitleColor(.white, for: .normal)
        view.layer.cornerRadius = 22.5
        view.layer.masksToBounds = true
        view.setTitle("Translate", for: .normal)
        return view
    }()
    
    var resultTableView: UITableView = {
        let view = UITableView()
        return view
    }()
    
    var sentenceTableView: UITableView = {
        let view = UITableView()
        return view
    }()
    
    var noSearchResult: UILabel = {
        let view = UILabel()
        view.text = "No search result."
        view.backgroundColor = .systemBackground
        view.textAlignment = .center
        view.textColor = .gray
        view.font = .systemFont(ofSize: 18)
        return view
    }()
    
    //MARK: configUI
    private func configUI() {
        title = "New"

        navigationItem.rightBarButtonItem = saveButton
        
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(textEditor)
        view.addSubview(searchButton)
        view.addSubview(translationEditor)
        view.addSubview(resultTableView)
        view.addSubview(sentenceTableView)
        view.addSubview(noSearchResult)
        
        textEditor.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        
        translationEditor.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(self.textEditor)
        }
        
        searchButton.snp.makeConstraints { make in
            make.width.equalTo(140)
            make.height.equalTo(45)
            make.trailing.bottom.equalTo(textEditor).inset(10)
        }

        resultTableView.snp.makeConstraints { make in
            make.top.equalTo(textEditor.snp.bottom).offset(20)
            make.leading.trailing.bottomMargin.equalToSuperview()
        }
        
        sentenceTableView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(resultTableView)
        }
        
        noSearchResult.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(resultTableView)
        }
        
        resultTableView.register(HeaderTitleSubtitleCell.self, forCellReuseIdentifier: HeaderTitleSubtitleCell.identifier)
        
        sentenceTableView.register(HeaderTitleSubtitleCell.self, forCellReuseIdentifier: HeaderTitleSubtitleCell.identifier)
    }
    

}
