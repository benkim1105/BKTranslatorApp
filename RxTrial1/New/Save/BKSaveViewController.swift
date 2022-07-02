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
    let imagePath: String? = nil
    
    var viewModel: BKSaveViewModelProtocol
    var showProgress: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var showError: PublishRelay<String> = PublishRelay()

    var player: AVPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Title"
        view.backgroundColor = .secondarySystemBackground
        
        coverImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didClickCover)))
        tableView.tableHeaderView = headerView
        tableView.rowHeight = 50
        tableView.allowsSelection = false

        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(didClickSave))
        navigationItem.rightBarButtonItem = saveButton

        viewModel.view = self
    }

    func playTemp(url: URL?) {
        guard let url = url else {
            print("no url")
            return
        }

        do {
            try? AVAudioSession.sharedInstance().setCategory(.playback)

            player = try AVPlayer(url: url)
            player?.play()
        } catch {
            print(error)
        }

    }

    @objc func didClickSave() {
        guard let title = titleCell.textField.text?.trimmingCharacters(in: .whitespaces), title.count > 0 else {
            HapticManager.shared.warning()
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return titleCell
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
