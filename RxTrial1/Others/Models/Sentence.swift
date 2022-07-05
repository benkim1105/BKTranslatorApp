//
//  Sentence.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/06/28.
//

import Foundation

struct BKSentence: Codable {
    let id: String?
    let bookId: String?
    let sentence: String
    let translation: String
    let sentenceLanguage: Language
    let translationLanguage: Language
    let timestamp: Date?
    let serverId: String?

    internal init(id: String? = UUID().uuidString, bookId: String? = nil, sentence: String, translation: String, sentenceLanguage: Language, translationLanguage: Language, timestamp: Date? = nil, serverId: String? = nil) {
        self.id = id
        self.bookId = bookId
        self.sentence = sentence
        self.translation = translation
        self.sentenceLanguage = sentenceLanguage
        self.translationLanguage = translationLanguage
        self.timestamp = timestamp
        self.serverId = serverId
    }
}

extension BKSentence {
    static var sample: BKSentence {
        BKSentence(id: "id", bookId: "bookId", sentence: "sentence", translation: "translation", sentenceLanguage: .ko, translationLanguage: .en, timestamp: Date(), serverId: "serverId")
    }
}
