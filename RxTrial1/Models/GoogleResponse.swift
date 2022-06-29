//
//  GoogleResponse.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/06/27.
//

import Foundation

struct GoogleResponse: Codable {
    let data: GoogleData?
}

struct GoogleData: Codable {
    let translations: [GoogleTranslation]?
}

struct GoogleTranslation: Codable {
    let translatedText: String?
}
