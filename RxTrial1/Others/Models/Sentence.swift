//
//  Sentence.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/06/28.
//

import Foundation

struct Sentence {
    let id: String?
    let script: String
    let translation: String
    let scriptLanguage: Language
    let translationLanguage: Language
    

    internal init(id: String? = UUID().uuidString, script: String, translation: String, scriptLanguage: Language, translationLanguage: Language) {
        self.id = id
        self.script = script
        self.translation = translation
        self.scriptLanguage = scriptLanguage
        self.translationLanguage = translationLanguage
    }
}
