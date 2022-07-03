//
//  TranslatorService.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/06/27.
//

import Foundation
import RxSwift

protocol TranslatorServiceProtocol {
    ///번역 검색
    func searchTranslation(
        text: String,
        source: Language,
        target: Language,
        engine: Engine
    ) -> Observable<Translation>
    
    ///번역한 걸 다시 번역 검색
    func searchMetaTranslation(
        text: String,
        source: Language,
        target: Language,
        engine: Engine
    ) -> Observable<MetaTranslation>
    
    ///모든 번역 엔진으로 양방향 검색
    func searchTranslationAll(text: String) -> Observable<MetaTranslation>
}

class BKTranslatorService: TranslatorServiceProtocol {
    let api: TranslatorAPIProtocol
    
    init(api: TranslatorAPIProtocol) {
        self.api = api
    }
    
    func searchTranslation(
        text: String,
        source: Language,
        target: Language,
        engine: Engine
    ) -> Observable<Translation> {
        switch engine {
        case .papago:
            return api.searchPapago(text: text, source: source, target: target)
                .map { $0.message?.result?.translatedText }
                .map { Translation(text: text, translation: $0) }
        case .google:
            return api.searchGoogle(text: text, source: source, target: target)
                .map { $0.data?.translations?.first?.translatedText }
                .map { $0?.withoutHtml }
                .map { Translation(text: text, translation: $0) }
        case .kakao:
            return api.searchKakao(text: text, source: source, target: target)
                .map { $0.translated_text?.first??.first }
                .map { Translation(text: text, translation: $0) }
        }
    }

    func searchMetaTranslation(
        text: String,
        source: Language,
        target: Language,
        engine: Engine
    ) -> Observable<MetaTranslation> {
            return searchTranslation(text: text, source: source, target: target, engine: engine)
                .flatMap { translation -> Observable<MetaTranslation> in
                    if let translationString = translation.translation {
                        return self.searchTranslation(
                            text: translationString,
                            source: target,
                            target: source,
                            engine: engine
                        )
                        .map {
                            MetaTranslation(
                                engine: engine,
                                translation: translation,
                                metaTranslation: $0
                            )
                        }
                    } else {
                        let nilTranslation = Translation(text: nil, translation: nil)
                        return Observable.just(
                            MetaTranslation(
                                engine: engine,
                                translation: translation,
                                metaTranslation: nilTranslation
                            ))
                    }
                }
    }
    
    func searchTranslationAll(text: String) -> Observable<MetaTranslation> {
        let papago = searchMetaTranslation(text: text, source: .ko, target: .en, engine: .papago)
        let google = searchMetaTranslation(text: text, source: .ko, target: .en, engine: .google)
        let kakao = searchMetaTranslation(text: text, source: .ko, target: .en, engine: .kakao)
        return Observable.merge(papago, google, kakao)
    }
}
