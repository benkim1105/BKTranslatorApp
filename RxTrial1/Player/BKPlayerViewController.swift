//
//  PlayerViewController.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/06/30.
//

import UIKit
import AVKit
class BKPlayerViewController: UIViewController {
    var player: AVPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow

//        try? AVAudioSession.sharedInstance().setCategory(.playback)
//
//        let mp3Directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("mp3")
//        let fileURL = mp3Directory.appendingPathComponent("A8EB41AB-70A2-4BE2-94D7-14FF45101B51.mp3")
//        print(fileURL)
//        player = AVPlayer(url: fileURL)
//        player?.play()
    }
}
