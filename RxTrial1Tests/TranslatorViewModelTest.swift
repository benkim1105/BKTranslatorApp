//
//  TranslatorViewModelTest.swift
//  RxTrial1Tests
//
//  Created by Ben KIM on 2022/06/29.
//

import XCTest
import RxSwift
@testable import RxTrial1

class TranslatorViewModelTest: XCTestCase {
    let disposeBag = DisposeBag()
    
    struct Call {
        static var stack: [String] = []
    }
    
    func test_번역검색을누르면_번역엔진3개찾아서_결과를화면에출력함() {
        //given
        let mockGoogle = GoogleResponse(data: GoogleData(translations: [GoogleTranslation(translatedText: "abc")]))
        let mockPapago = PapagoResponse(message: PapagoMessage(result: PapagoResult(translatedText: "abc")))
        let mockKakao = KakaoResponse(translated_text: [["abc"]])
        let api = MockApi()
        api.mockGoogle = mockGoogle
        api.mockPapago = mockPapago
        api.mockKakao = mockKakao
        let model = TranslatorService(api: api)
        let viewModel = TranslatorViewModel(model: model)
        
        let exp = XCTestExpectation()
        //when
        viewModel.search(text: "만나서 반갑습니다.")

        viewModel.searchResults.subscribe { result in
            //then
            XCTAssertEqual(6, Call.stack.count)
            XCTAssertTrue(Call.stack.contains(where: { $0 == "searchGoogle" }))
            XCTAssertTrue(Call.stack.contains(where: { $0 == "searchKakao" }))
            XCTAssertTrue(Call.stack.contains(where: { $0 == "searchPapago" }))
            
            XCTAssertEqual(3, viewModel.searchResults.value.count)
            
            exp.fulfill()
        } onError: { error in
            print(error)
            XCTFail(error.localizedDescription)
        }
        .disposed(by: disposeBag)

        wait(for: [exp], timeout: 1)
    }
    
    class MockApi: APIProtocol {
        var mockGoogle: GoogleResponse?
        var mockKakao: KakaoResponse?
        var mockPapago: PapagoResponse?
        
        func searchGoogle(text: String, source: Language, target: Language) -> Observable<GoogleResponse> {
            Call.stack.append("searchGoogle")
            return Observable.just(mockGoogle!)
        }
        
        func searchKakao(text: String, source: Language, target: Language) -> Observable<KakaoResponse> {
            Call.stack.append("searchKakao")
            return Observable.just(mockKakao!)
        }
        
        func searchPapago(text: String, source: Language, target: Language) -> Observable<PapagoResponse> {
            Call.stack.append("searchPapago")
            return Observable.just(mockPapago!)
        }
    }
}
