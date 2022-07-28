//
//  BKPlayerViewModelTest.swift
//  RxTrial1Tests
//
//  Created by Ben KIM on 2022/07/17.
//

import XCTest
@testable import RxTrial1
import AVFoundation
import RxSwift


class BKPlayerViewModelTest: XCTestCase {
    
    func test_재생정지이동하면_정상으로작동() {
        //given
        let mockPlayer = MockPlayer()
        let viewModel = BKPlayerViewModel(player: mockPlayer)
        let items = [
            BKPlayerItem(sentence: "testSentence1", translation: "testTranslation1", ttsURL: URL(fileURLWithPath: "mockURL1")),
            BKPlayerItem(sentence: "testSentence2", translation: "testTranslation2", ttsURL: URL(fileURLWithPath: "mockURL2"))]
        

        viewModel.loadItems(items: items)
        viewModel.viewDidLoad()
        
        //when 재생하면
        viewModel.play()
        
        //then 재생 상태로 변경
        XCTAssertEqual(.playing, try! viewModel.playbackState.value())
        
        //when 일시정지하면
        viewModel.pause()
        
        //then 일시정지
        XCTAssertEqual(.paused, try! viewModel.playbackState.value())
        
        //when 다음 이동하면
        viewModel.next()
        
        //then 다음으로 이동
        XCTAssertEqual(1, try! viewModel.currentItemIdx.value())
        
        //when 끝에서 다음으로 이동하면
        viewModel.next()
        
        //then 처음으로 이동
        XCTAssertEqual(0, try! viewModel.currentItemIdx.value())
        
        //when 처음에서 이전으로 가면
        viewModel.prev()
        
        //then 마지막으로 이동
        XCTAssertEqual(1, try! viewModel.currentItemIdx.value())
    }
    
    func test_Loop켜고재생하면_처음으로돌아간다() {
        //given
        let mockPlayer = MockPlayer()
        let viewModel = BKPlayerViewModel(player: mockPlayer)
        let items = [
            BKPlayerItem(sentence: "testSentence1", translation: "testTranslation1", ttsURL: URL(fileURLWithPath: "mockURL1")),
            BKPlayerItem(sentence: "testSentence2", translation: "testTranslation2", ttsURL: URL(fileURLWithPath: "mockURL2"))]
        let disposeBag = DisposeBag()

        viewModel.loadItems(items: items)
        viewModel.viewDidLoad()
        
        //when loop 켜고 재생하면
        viewModel.currentItemIdx.onNext(1)
        viewModel.loop.onNext(true)
        viewModel.play()

        //given player는 1초 후에 무조건 다음 문장으로 이동하도록 되어 있다.
        let exp = XCTestExpectation()
        
        //then 마지막에서 처음으로 이동
        viewModel.currentItemIdx.skip(1).bind { idx in
            XCTAssertTrue(idx == 0)
            XCTAssertEqual(try! viewModel.playbackState.value(), .playing)
            viewModel.pause()
            exp.fulfill()
        }
        .disposed(by: disposeBag)
        wait(for: [exp], timeout: 2)
        
    }
    
    func test_loop끄고재생하면_완료시멈춘다() {
        //given
        let mockPlayer = MockPlayer()
        let viewModel = BKPlayerViewModel(player: mockPlayer)
        let items = [
            BKPlayerItem(sentence: "testSentence1", translation: "testTranslation1", ttsURL: URL(fileURLWithPath: "mockURL1")),
            BKPlayerItem(sentence: "testSentence2", translation: "testTranslation2", ttsURL: URL(fileURLWithPath: "mockURL2"))]
        let disposeBag = DisposeBag()
        
        viewModel.loadItems(items: items)
        viewModel.viewDidLoad()
        
        //when 마지막에서 loop 끄고 재생하면
        viewModel.currentItemIdx.onNext(1)
        viewModel.loop.onNext(false)
        viewModel.play()
        
        //given player는 1초 후에 무조건 다음 문장으로 이동하도록 되어 있다.
        let exp = XCTestExpectation()
        
        viewModel.playbackState
            .skip(1).bind { state in
            //then 재생 정지
            XCTAssertEqual(state, .paused)
            //then 마지막 문장에서 그대로 대기
            XCTAssertEqual(1, try! viewModel.currentItemIdx.value())
            
            exp.fulfill()
        }
        .disposed(by: disposeBag)
        
        wait(for: [exp], timeout: 2)
    }
    
    class MockPlayer: BKPlayerProtocol {
        func replaceCurrentItem(with url: URL) {
            //do nothing
        }
        
        func pause() {
            //do nothing
        }
        
        func play() {
            // 1초후 무조건 재생 완료 노티를 보낸다.
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                NotificationCenter.default.post(name: .AVPlayerItemDidPlayToEndTime, object: nil)
            }
        }
        
        func seek(to: CMTime) {
            //do nothing
        }
    }
}
