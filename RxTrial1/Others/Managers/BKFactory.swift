//
//  BKFactory.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/06/27.
//

import Foundation

class BKFactory {
    static let shared = BKFactory()
    private let api: API
    private let networkService: NetworkService
    
    private init() {
        networkService = NetworkService()
        api = API(networkService: networkService)
    }
    
    func translatorViewModel() -> TranslatorViewModel {
        let model = TranslatorService(api: api)
        let viewModel = TranslatorViewModel(model: model)
        return viewModel
    }
}
