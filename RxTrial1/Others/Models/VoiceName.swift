//
//  VoiceName.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/06/29.
//

import Foundation

enum VoiceName: String, CaseIterable {
    case ko_KR_Wavenet_A = "ko-KR-Wavenet-A"
    case ko_KR_Wavenet_B = "ko-KR-Wavenet-B"
    case ko_KR_Wavenet_C = "ko-KR-Wavenet-C"
    case ko_KR_Wavenet_D = "ko-KR-Wavenet-D"
    
    case en_US_Wavenet_B = "en-US-Wavenet-B"
    case en_US_Wavenet_C = "en-US-Wavenet-C"
    case en_US_Wavenet_D = "en-US-Wavenet-D"
    case en_US_Wavenet_E = "en-US-Wavenet-E"
    case en_US_Wavenet_F = "en-US-Wavenet-F"
    case en_US_Wavenet_G = "en-US-Wavenet-G"
    case en_US_Wavenet_H = "en-US-Wavenet-H"
    case en_US_Wavenet_I = "en-US-Wavenet-I"
    case en_US_Wavenet_J = "en-US-Wavenet-J"
    
    static func voiceNames(language: Language) -> [VoiceName] {
        let languageCountry = language.languageCountry()
        return VoiceName.allCases.filter { $0.rawValue.starts(with: languageCountry) }
    }
}
