//
//  BKDataServiceTest.swift
//  RxTrial1Tests
//
//  Created by Ben KIM on 2022/07/03.
//

import XCTest
@testable import RxTrial1
import RxSwift
import CoreData
import SwiftUI

class BKDataServiceTest: XCTestCase {
    let disposeBag = DisposeBag()
    var context: NSManagedObjectContext? = nil
    
    override func setUp() async throws {
        let exp = XCTestExpectation()
        let container = NSPersistentContainer(name: "translator")
        container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        container.loadPersistentStores(completionHandler: { [weak self] (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            
            self?.context = container.viewContext
            exp.fulfill()
        })
        wait(for: [exp], timeout: 1)
    }
    
    func test_데이터하나입출력테스트() {
        //given
        let mockContext = context
        let dataService = BKLocalDataService(managedObjectContext: mockContext!)
        
        //when
        let episode = BKEpisode(id: "id", title: "title", image: "image")

        dataService.save(episode, type: "Episode")
            .subscribe { serverId in
                XCTAssertNotNil(serverId)
            } onError: { error in
                print(error)
                XCTFail()
            }
            .disposed(by: disposeBag)
           
        //Then
        dataService.getElement(type: "Episode", id: "id")
            .subscribe { (episode: BKEpisode?) in
                XCTAssertNotNil(episode)
                print(episode ?? "nil")
                
                XCTAssertEqual("id", episode?.id)
                XCTAssertNotNil(episode?.serverId)
                XCTAssertEqual("title", episode?.title)
                XCTAssertEqual("image", episode?.image)
                XCTAssertNotNil(episode?.timestamp)
                
            } onError: { error in
                print(error)
                XCTFail()
            }
            .disposed(by: disposeBag)
    }
    
    func test_데이터목록입출력테스트() {
        //given
        let mockContext = context
        let dataService = BKLocalDataService(
            managedObjectContext: mockContext!)
        
        var sentenceList: [BKSentence] = []
        for idx in 0..<10 {
            let tempSentence = BKSentence(
                id: "id\(idx)",
                bookId: "bookId\(idx)",
                sentence: "sentence\(idx)",
                translation: "translation\(idx)",
                sentenceLanguage: .ko,
                translationLanguage: .en
            )
            sentenceList.append(tempSentence)
        }
        
        //when
        dataService.saveList(sentenceList, type: "Sentence")
            .subscribe { serverIds in
                XCTAssertNotNil(serverIds)
                XCTAssertEqual(10, serverIds.count)
            } onError: { error in
                print(error)
                XCTFail()
            }
            .disposed(by: disposeBag)
           
        //Then
        dataService.getList(type: "Sentence", startToken: nil, count: nil, order: [("id", true)])
            .subscribe { (list: ListResult<BKSentence>) in
                XCTAssertNotNil(list)
                print(list)
                
                XCTAssertEqual(10, list.items.count)
                
                let sentence = list.items.first!
                XCTAssertEqual("id0", sentence.id)
                XCTAssertNotNil(sentence.serverId)
                XCTAssertEqual("sentence0", sentence.sentence)
                XCTAssertEqual("translation0", sentence.translation)
                XCTAssertEqual(.ko, sentence.sentenceLanguage)
                XCTAssertEqual(.en, sentence.translationLanguage)
                
            } onError: { error in
                print(error)
                XCTFail()
            }
            .disposed(by: disposeBag)
    }

}
