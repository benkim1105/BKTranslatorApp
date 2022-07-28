//
//  BKPlayer.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/07/28.
//

import Foundation
import AVFoundation
import RxSwift


protocol BKPlayerProtocol {
    func replaceCurrentItem(with url: URL)
    func play()
    func pause()
    func seek(to: CMTime)
}

enum BKPlaybackState: Int {
    case undefined
    case playing
    case paused
}

class BKPlayer: BKPlayerProtocol {
    private let player = AVPlayer()
    
    func replaceCurrentItem(with url: URL) {
        player.pause()
        player.replaceCurrentItem(with: AVPlayerItem(url: url))
    }
    
    func pause() {
        player.pause()
    }
    
    func play() {
        player.play()
    }
    
    func seek(to time: CMTime) {
        player.seek(to: time)
    }
}
