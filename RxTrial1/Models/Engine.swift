//
//  Engine.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/06/27.
//

import Foundation


enum Engine: String {
    case papago
    case google
    case kakao
    
    var name: String {
        switch self {
        case .papago:
            return "Papago"
        case .google:
            return "Google"
        case .kakao:
            return "Kakao"
        }
    }
}
