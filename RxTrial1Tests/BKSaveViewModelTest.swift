//
//  BKSaveViewModelTest2.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/07/02.
//
//

import XCTest
import RxSwift
import RxRelay
@testable import RxTrial1

class BKSaveViewModelTest: XCTestCase {
    struct Call {
        static var stack: [String] = []
    }

    func test_저장하기누르면_프로그래스띄우고_book저장_sentence저장_이미지저장_tts가져오기_tts저장_프로그래스감추고_완료() {
        let disposeBag = DisposeBag()
        
        //given
        let sentences = [BKSentence(
            sentence: "안녕",
            translation: "hello",
            sentenceLanguage: .ko,
            translationLanguage: .en)]
        let api = MockAPI()

        let fileService = MockFileService()
        let dataService = MockDataService()
        let remoteService = MockRemoteService()
        let mockModel = BKSaveModel(api: api, localFileService: fileService, dataService: dataService, remoteFileService: remoteService)
        let mockView = MockView()
        mockView.showProgress.subscribe {
            Call.stack.append("showProgress:\($0.element!)")
        }
        .disposed(by: disposeBag)
        
        let viewModel = BKSaveViewModel(sentences: sentences, model: mockModel)
        viewModel.view = mockView

        //when
        viewModel.save(title: "asdf", image: nil)

        //then
        let stack = Call.stack.joined(separator: ",")
        
        XCTAssertEqual("showProgress:false,showProgress:true,save:Episode,saveList:Sentence,tts,saveLocalFile:mp3,showProgress:false,onSaveCompletion", stack)

    }

    class MockAPI: TranslatorAPIProtocol {
        func tts(id: String, text: String, language: Language, voiceName: VoiceName) -> Observable<Data> {
            Call.stack.append("tts")
            let mockTTSData = "".data(using: .utf8)!
            return Observable.just(mockTTSData)
        }

        func searchGoogle(text: String, source: Language, target: Language) -> Observable<GoogleResponse> {
            fatalError("searchGoogle(text:source:target:) has not been implemented")
        }

        func searchKakao(text: String, source: Language, target: Language) -> Observable<KakaoResponse> {
            fatalError("searchKakao(text:source:target:) has not been implemented")
        }

        func searchPapago(text: String, source: Language, target: Language) -> Observable<PapagoResponse> {
            fatalError("searchPapago(text:source:target:) has not been implemented")
        }
    }

    class MockView: BKSaveViewProtocol {
        var showProgress: BehaviorRelay<Bool> = BehaviorRelay(value: false)
        var showError: PublishRelay<String> = PublishRelay()

        func onSaveCompletion() {
            Call.stack.append("onSaveCompletion")
        }
    }

    class MockFileService: BKLocalFileServiceProtocol {
        func directory(with type: BKFileType) -> URL? {
            URL(fileURLWithPath: "/dev/null")
        }

        func saveFile(type: BKFileType, data: Data, name: String) -> URL? {
            Call.stack.append("saveLocalFile:" + type.rawValue)
            return directory(with: type)!.appendingPathComponent(name)
        }

        func filePath(type: BKFileType, name: String) -> URL? {
            directory(with: type)!.appendingPathComponent(name)
        }
    }
    
    class MockDataService: BKDataServiceProtocol {
        func getList<E>(type: DataElementType, idList: [LocalId]) -> Observable<ListResult<E>> where E : Decodable, E : Encodable {
            fatalError()
        }
        
        
        func save<E>(_ element: E, type: DataElementType) -> Observable<ServerId> where E : Decodable, E : Encodable {
            Call.stack.append("save:" + type.rawValue)
            return Observable.just("")
        }
        
        func saveList<E>(_ list: [E], type: DataElementType) -> Observable<[ServerId]> where E : Decodable, E : Encodable {
            Call.stack.append("saveList:" + type.rawValue)
            return Observable.just([])
        }
        
        func getElement<E>(type: DataElementType, id: String) -> Observable<E?> where E : Decodable, E : Encodable {
            fatalError()
        }
        
        func getList<E>(type: DataElementType, startToken: String?, count: Int?, order: [(String, OrderDirection)]?) -> Observable<ListResult<E>> where E : Decodable, E : Encodable {
            fatalError()
        }
        
    }
    
    class MockRemoteService: BKRemoteFileServiceProtocol {
        func saveImageFile(image: UIImage?, name: String, quality: CGFloat) -> Observable<RemoteImage?> {
            Call.stack.append("saveImageFile")
            
            return Observable.just(RemoteImage(url: name, width: 100, height: 100, isLocal: true))
        }
    }
}
