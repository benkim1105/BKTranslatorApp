//
//  BKPlayerViewModel.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/07/17.
//

import Foundation
import AVFoundation
import RxSwift

struct BKPlayerItem {
    let sentence: String
    let translation: String
    let ttsURL: URL
}

protocol BKPlayerViewProtocol: AnyObject {
    var viewModel: BKPlayerViewModelProtocol { get set }
}

protocol BKPlayerViewModelProtocol: AnyObject {
    var view: BKPlayerViewProtocol? { get set }
    var currentItemIdx: BehaviorSubject<Int> { get set }
    var playbackState: BehaviorSubject<BKPlaybackState> { get }
    var loop: BehaviorSubject<Bool> { get set }
    var items: [BKPlayerItem] { get set }
    var player: BKPlayerProtocol { get set }
    
    func loadItems(items: [BKPlayerItem])
    func play()
    func pause()
    func next()
    func prev()
    func viewDidLoad()
}

class BKPlayerViewModel: BKPlayerViewModelProtocol {
    weak var view: BKPlayerViewProtocol?
    var player: BKPlayerProtocol
    
    var items: [BKPlayerItem] = []
    var loop = BehaviorSubject(value: true)
    var currentItemIdx = BehaviorSubject(value: 0)
    var playbackState = BehaviorSubject<BKPlaybackState>(value: .undefined)
    
    private var disposeBag = DisposeBag()

    init(player: BKPlayerProtocol) {
        self.player = player
    }
    
    func viewDidLoad() {
        bindItem()
        currentItemIdx.onNext(0)
    }
    
    private func bindItem() {
        currentItemIdx
            .subscribe(onNext: { [weak self] idx in
                guard let self = self, idx < self.items.count else {
                    return
                }
                
                let currentItem = self.items[idx]
                self.player.replaceCurrentItem(with: currentItem.ttsURL)
                self.player.seek(to: CMTime.zero)
                
                if let state = try? self.playbackState.value(), state == .playing {
                    self.player.play()
                }
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(.AVPlayerItemDidPlayToEndTime)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else {
                    return
                }
                
                if let currentItemIdx = try? self.currentItemIdx.value(),
                   currentItemIdx >= (self.items.count - 1),
                   let loop = try? self.loop.value(),
                   !loop {
                    
                    self.pause()
                } else {
                    self.next()
                }
            })
            .disposed(by: self.disposeBag)
    }

    //MARK: - BKPlayerViewModelProtocol
    func loadItems(items: [BKPlayerItem]) {
        self.items = items
    }
    
    func play() {
        guard items.count > 0 else {
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            player.seek(to: .zero)
            player.play()
            playbackState.onNext(.playing)
        } catch {
            //do nothing
        }
    }
    
    func pause() {
        player.pause()
        playbackState.onNext(.paused)
    }
    
    func next() {
        guard let currentItemIdx = try? self.currentItemIdx.value() else {
            return
        }
        
        var nextIdx = 0
        if currentItemIdx < items.count - 1 {
            nextIdx = currentItemIdx + 1
        }
        
        if items.count > 0, currentItemIdx != nextIdx {
            self.currentItemIdx.onNext(nextIdx)
        }
    }
    
    func prev() {
        guard let currentItemIdx = try? self.currentItemIdx.value() else {
            return
        }
        
        var nextIdx = items.count - 1
        if currentItemIdx > 0 {
            nextIdx = currentItemIdx - 1
        }
        
        if items.count > 0, currentItemIdx != nextIdx {
            self.currentItemIdx.onNext(nextIdx)
        }
    }
}
