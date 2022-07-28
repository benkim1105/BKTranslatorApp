//
//  BKArchiveViewModelTest.swift
//  RxTrial1Tests
//
//  Created by Ben KIM on 2022/07/06.
//

import XCTest
@testable import RxTrial1

import RxSwift

class BKArchiveViewModelTest: XCTestCase {

    struct Call {
        static var stack: [String] = []
    }
    
    func test_화면뜨면_데이터가져와서출력() {
        //given
        let mockSentences = ListResult(items: [BKSentence.sample], nextStartToken: nil)
        let mockEpisodes = ListResult(items: [BKEpisode.sample], nextStartToken: nil)
        let mockDataService = MockDataService()
        mockDataService.mockSentences = mockSentences
        mockDataService.mockEpisodes = mockEpisodes
        
        let model = BKArchivewModel(dataService: mockDataService)
        let mockView = MockArchiveView()
        let viewModel = BKArchiveViewModel(model: model)
        viewModel.view = mockView
        
        //when
        viewModel.viewDidLoad()
        
        //then
        XCTAssertTrue(Call.stack.contains { $0 == "getList:Episode" })
        XCTAssertTrue(Call.stack.contains { $0 == "getList:Sentence" })
        XCTAssertTrue(try mockView.sentences.value().count > 0)
        XCTAssertTrue(try mockView.episodes.value().count > 0)
    }
    
    class MockArchiveView: BKArchiveViewProtocol {
        var episodes: BehaviorSubject<[BKEpisode]> = BehaviorSubject(value: [])
        var sentences: BehaviorSubject<[BKSentence]> = BehaviorSubject(value: [])
        
        func showError(_ message: String) {
            
        }
    }
    
    class MockDataService: BKDataServiceProtocol {
        var mockSentences: ListResult<BKSentence>?
        var mockEpisodes: ListResult<BKEpisode>?
        
        func getList<E>(type: DataElementType, startToken: String?, count: Int?, order: [(String, OrderDirection)]?) -> Observable<ListResult<E>> where E : Decodable, E : Encodable {
            Call.stack.append("getList:" + type.rawValue)
            
            switch type {
            case .Episode:
                return Observable.just(mockEpisodes as! ListResult<E>)
            case .Sentence:
                return Observable.just(mockSentences as! ListResult<E>)
            case .USentence:
                return Observable.just(ListResult(items: [], nextStartToken: nil))
            }
        }
        
        func getElement<E>(type: DataElementType, id: String) -> Observable<E?> where E : Decodable, E : Encodable {
            fatalError()
        }
        
        func save<E>(_ element: E, type: DataElementType) -> Observable<ServerId> where E : Decodable, E : Encodable {
            fatalError()
        }
        
        func saveList<E>(_ list: [E], type: DataElementType) -> Observable<[ServerId]> where E : Decodable, E : Encodable {
            fatalError()
        }
        
        func getList<E>(type: DataElementType, idList: [LocalId]) -> Observable<ListResult<E>> where E : Decodable, E : Encodable {
            fatalError()
        }
    }
}
