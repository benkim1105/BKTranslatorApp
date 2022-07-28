//
//  BKSaveViewController.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/06/29.
//

import UIKit
import SnapKit
import RxSwift
import RxRelay
import AVKit


class BKSaveViewController: UITableViewController, BKSaveViewProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let disposeBag = DisposeBag()
    
    let imagePath: String? = nil
    
    var viewModel: BKSaveViewModelProtocol
    var showProgress: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var showError: PublishRelay<String> = PublishRelay()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Title"
        
        configUI()
        viewModel.view = self

        bindUI()
    }

    func onSaveCompletion() {
        confirm(message: "저장완료!")
        
        let todo = "저장 후 화면 이동"
    }
    

    @objc func didClickSave() {
        guard let title = titleCell.textField.text?.trimmingCharacters(in: .whitespaces), title.count > 0 else {
            BKHapticService.shared.warning()
            return
        }
        viewModel.save(title: title, image: coverImageView.image)
    }
    
    @objc func didClickCover() {
        let imagePickerView = UIImagePickerController()
        imagePickerView.delegate = self
        self.present(imagePickerView, animated: true)
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.image = image
        dismiss(animated: true)
    }

    //MARK: view binding
    fileprivate func bindUI() {
        showProgress.subscribe(onNext: { [weak self] show in
            self?.progressContainer.isHidden = !show
            if show {
                self?.progress.startAnimating()
            } else {
                self?.progress.stopAnimating()
            }
        })
        .disposed(by: disposeBag)

        showError.subscribe(onNext: { [weak self] message in
            self?.complain(message: message)
        })
        .disposed(by: disposeBag)
    }
    
    //MARK: configUI
    let coverImageView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        view.image = UIImage(systemName: "photo.on.rectangle.angled", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40))
        view.contentMode = .center
        view.isUserInteractionEnabled = true
        view.backgroundColor = .systemBackground
        view.clipsToBounds = true
        return view
    }()

    lazy var headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        view.addSubview(coverImageView)
        coverImageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(30)
        }
        return view
    }()

    let titleCell: TextFieldCell = {
        let view = TextFieldCell()
        view.textField.placeholder = "제목을 입력하세요."
        return view
    }()

    let progress: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        return view
    }()

    let progressContainer: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = .systemBackground
        view.alpha = 0.5
        return view
    }()

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return titleCell
    }
    
    fileprivate func configUI() {
        view.backgroundColor = .secondarySystemBackground
        
        coverImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didClickCover)))
        
        tableView.tableHeaderView = headerView
        tableView.rowHeight = 50
        tableView.allowsSelection = false
        
        view.addSubview(progressContainer)
        progressContainer.addSubview(progress)
        progress.snp.makeConstraints { (make: ConstraintMaker) in
            make.centerX.centerX.equalToSuperview()
        }
        progressContainer.snp.makeConstraints { (make: ConstraintMaker) in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(didClickSave))
        navigationItem.rightBarButtonItem = saveButton
    }

    //MARK: - init
    
    init(viewModel: BKSaveViewModelProtocol) {
        self.viewModel = viewModel
    
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
