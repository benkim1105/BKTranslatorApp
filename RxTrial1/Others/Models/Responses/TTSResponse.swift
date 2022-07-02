//
//  TTSResponse.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/06/29.
//

import Foundation

struct TTSResponse: Codable {
    let id: String?
    let base64: String?
    let text: String
}
