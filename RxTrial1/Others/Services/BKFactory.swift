//
//  BKFactory.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/06/27.
//

import Foundation
import UIKit

class BKFactory {
    static let shared = BKFactory()

    let api: TranslatorAPI
    let networkService: BKNetworkService
    let localFileService: BKLocalFileService
    let dataService: BKLocalDataService
    let remoteFileService: BKRemoteFileService
    
    private init() {
        networkService = BKNetworkService()
        api = TranslatorAPI(networkService: networkService)
        localFileService = BKLocalFileService()
        remoteFileService = BKRemoteFileService(fileService: localFileService)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataService = BKLocalDataService(managedObjectContext: appDelegate.persistentContainer.viewContext)
    }
    
    func player() -> BKPlayer {
        let player = BKPlayer()
        return player
    }
    
    func newViewModel() -> BKNewViewModel {
        let model = BKTranslatorService(api: api)
        let viewModel = BKNewViewModel(model: model)
        return viewModel
    }
    
    func saveViewModel(sentences: [BKSentence]) -> BKSaveViewModel {
        let model = BKSaveModel(api: api, localFileService: localFileService, dataService: dataService, remoteFileService: remoteFileService)
        let viewModel = BKSaveViewModel(sentences: sentences, model: model)
        return viewModel
    }
    
    func archiveViewModel() -> BKArchiveViewModel {
        let model = BKArchivewModel(dataService: dataService)
        let viewModel = BKArchiveViewModel(model: model)
        return viewModel
    }
}
