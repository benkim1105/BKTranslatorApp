//
//  PapagoResponse.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/06/27.
//

import Foundation

struct PapagoResponse: Codable {
    let message: PapagoMessage?
}

struct PapagoMessage: Codable {
    let result: PapagoResult?
}

struct PapagoResult: Codable {
    let translatedText: String?
}
