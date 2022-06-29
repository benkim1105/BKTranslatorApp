//
//  RxTrial1Tests.swift
//  RxTrial1Tests
//
//  Created by Ben KIM on 2022/06/26.
//

import XCTest
import RxSwift
@testable import RxTrial1

class TranslatorServiceTest: XCTestCase {
    let disposeBag = DisposeBag()
    
    struct Call {
        static var stack: [String] = []
    }
    
    func test_MetaTranslation을검색하면_번역과번역에대한번역이회신됨() {
        //given
        let mockResult = PapagoResponse(message: PapagoMessage(result: PapagoResult(translatedText: "abc")))
        
        let networkService = MockNetworkService()
        networkService.mockResult = mockResult
        let api = API(networkService: networkService)
        let translationService = TranslatorService(api: api)
        let text = "만나서 반갑습니다."

        let exp = XCTestExpectation()
        //when
        translationService.searchMetaTranslation(
            text: text,
            source: .ko,
            target: .en,
            engine: .papago
        )
        .subscribe { result in
            XCTAssertEqual("abc", result.translation.translation)
            XCTAssertEqual("abc", result.metaTranslation.translation)
            XCTAssertEqual("api,api", Call.stack.joined(separator: ","))
        } onError: { error in
            print(error)
            XCTFail(error.localizedDescription)
        } onCompleted: {
            exp.fulfill()
        }
        .disposed(by: disposeBag)
        
        wait(for: [exp], timeout: 1)
    }
    
    class MockNetworkService: NetworkServiceProtocol {
        var mockResult: Any?
        
        func execute<T>(_ url: String, method: String, params: [String : String], headers: [String : String]) -> Observable<T> where T : Decodable {
            Call.stack.append("api")
            return Observable.just(mockResult as! T)
        }
    }
}


