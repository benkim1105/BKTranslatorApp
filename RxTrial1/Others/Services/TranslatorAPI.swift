//
//  API.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/06/27.
//

import Foundation
import RxSwift

enum APIError: Error {
    case invalidParameter
    case internalError
}

protocol TranslatorAPIProtocol {
    func searchGoogle(text: String, source: Language, target: Language) -> Observable<GoogleResponse>
    
    func searchKakao(text: String, source: Language, target: Language) -> Observable<KakaoResponse>
    
    func searchPapago(text: String, source: Language, target: Language) -> Observable<PapagoResponse>
    
    func tts(id: String, text: String, language: Language, voiceName: VoiceName) -> Observable<Data>
}

class TranslatorAPI: TranslatorAPIProtocol {
    let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func tts(id: String, text: String, language: Language, voiceName: VoiceName) -> Observable<Data> {
        let base = "http://192.168.0.48:8080"
        let urlString = base + "/api/tts"
        let params = ["id": id, "text": text, "voiceName": voiceName.rawValue, "language": language.languageCountry()]
        
        return networkService.executeData(urlString, method: "POST", params: params, headers: [:])
    }
    
    func searchGoogle(text: String, source: Language, target: Language) -> Observable<GoogleResponse> {
        let urlString = "https://translation.googleapis.com/language/translate/v2"
        let params = ["source":source.value(), "target":target.value(), "q": text, "key": ApiKeys.GoogleKey]

        return networkService.execute(urlString, method: "GET", params: params, headers: [:])
    }
    
    func searchKakao(text: String, source: Language, target: Language) -> Observable<KakaoResponse> {
        let urlString = "https://dapi.kakao.com/v2/translation/translate"
        let params = ["src_lang":source.value(isKaKao: true), "target_lang":target.value(isKaKao: true), "query": text]
        let headers = ["Authorization": "KakaoAK \(ApiKeys.KakaoKey)"]
        
        return networkService.execute(urlString, method: "POST", params: params, headers: headers)
    }
    
    func searchPapago(text: String, source: Language, target: Language) -> Observable<PapagoResponse> {
        let urlString = "https://openapi.naver.com/v1/papago/n2mt"
        let params = ["source":source.value(), "target":target.value(), "text":text]
        let headers = [
            "Content-Type":"application/x-www-form-urlencoded; charset=UTF-8",
            "X-Naver-Client-Id": ApiKeys.NaverClientId,
            "X-Naver-Client-Secret": ApiKeys.NaverClientSecret
        ]

        return networkService.execute(urlString, method: "POST", params: params, headers: headers)
    }
}
