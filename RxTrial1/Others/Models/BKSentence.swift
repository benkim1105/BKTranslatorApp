//
//  Sentence.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/06/28.
//

import Foundation

struct BKSentence: Codable {
    var id: String?
    var bookId: String?
    var sentence: String
    var translation: String
    var sentenceLanguage: Language
    var translationLanguage: Language
    var timestamp: Date?
    var serverId: String?

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
