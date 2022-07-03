//
//  Language.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/06/27.
//

import Foundation

enum Language: String, Codable {
    case en
    case ko
    
    func value(isKaKao: Bool = false) -> String {
        if isKaKao {
            if self == .ko {
                return "kr"
            } else {
                return self.rawValue
            }
        } else {
            return self.rawValue
        }
    }
    
    func languageCountry() -> String {
        switch self {
        case .en:
            return "en-US"
        case .ko:
            return "ko-KR"
        }
    }
}
