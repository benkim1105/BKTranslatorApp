//
//  HapticManager.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/06/28.
//

import Foundation
import UIKit

class BKHapticService {
    static let shared = BKHapticService()
    
    let generator: UINotificationFeedbackGenerator
    
    private init() {
        generator = UINotificationFeedbackGenerator()
        generator.prepare()
    }
    
    func warning() {
        generator.notificationOccurred(.warning)
    }
    
    func error() {
        generator.notificationOccurred(.error)
    }
}
