//
//  Language.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/06/27.
//

import Foundation

enum Language: String {
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
}
