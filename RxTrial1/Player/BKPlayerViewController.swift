//
//  PlayerViewController.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/06/30.
//

import UIKit
import AVKit
import RxSwift
import SnapKit

class BKPlayerViewController: UIViewController, BKPlayerViewProtocol {
    var player: AVPlayer?
    var viewModel: BKPlayerViewModelProtocol
    var buttonPlay: UIButton!
    var buttonLoop: UIButton!
    private var disposeBag = DisposeBag()
    
    let currentIdx: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    init(viewModel: BKPlayerViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc private func didClickPlayPause() {
        guard let state = try? viewModel.playbackState.value() else {
            return
        }
        
        if state == .playing {
            viewModel.pause()
        } else {
            viewModel.play()
        }
    }
    
    @objc private func didClickLoop() {
        guard let isLooping = try? viewModel.loop.value() else {
            return
        }
        
        viewModel.loop.onNext(!isLooping)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        view.addSubview(currentIdx)
        currentIdx.snp.makeConstraints { make in
            make.leading.trailing.top.bottomMargin.equalToSuperview().inset(50)
        }

        buttonPlay = UIButton(type: .custom)
        buttonPlay.setImage(UIImage(systemName: "play"), for: .normal)
        buttonPlay.setImage(UIImage(systemName: "pause"), for: .selected)
        buttonPlay.addTarget(self, action: #selector(didClickPlayPause), for: .touchUpInside)
        let buttonBarItem = UIBarButtonItem(customView: buttonPlay)
        
        buttonLoop = UIButton(type: .custom)
        buttonLoop.setImage(UIImage(systemName: "repeat.circle"), for: .normal)
        buttonLoop.setImage(UIImage(systemName: "repeat.circle.fill"), for: .selected)
        buttonLoop.addTarget(self, action: #selector(didClickLoop), for: .touchUpInside)
        let buttonLoopBarItem = UIBarButtonItem(customView: buttonLoop)
        
        toolbarItems = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            buttonBarItem,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            buttonLoopBarItem]
        self.setToolbarItems(toolbarItems, animated: false)
        self.navigationController?.setToolbarHidden(false, animated: false)
        
        bindUI()
        
        viewModel.view = self
        viewModel.viewDidLoad()
    }
    
    private func bindUI() {
        viewModel.currentItemIdx
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] idx in
                guard let self = self else {
                    return
                }
                
                self.currentIdx.text = "\(idx + 1) / \(self.viewModel.items.count)\n\(self.viewModel.items[idx].sentence)\n\(self.viewModel.items[idx].translation)"
            })
            .disposed(by: disposeBag)
        
        viewModel.playbackState
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] state in
                switch state {
                case .paused:
                    self?.buttonPlay.isSelected = false
                case .playing:
                    self?.buttonPlay.isSelected = true
                default:
                    self?.buttonPlay.isSelected = false
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.loop
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] loop in
                self?.buttonLoop.isSelected = loop
            })
            .disposed(by: disposeBag)
    }
}
