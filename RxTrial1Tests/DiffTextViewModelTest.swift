//
//  DiffTextViewModelTest.swift
//  RxTrial1Tests
//
//  Created by Ben KIM on 2022/07/16.
//

import XCTest
import RxSwift
@testable import RxTrial1


class DiffTextViewModelTest: XCTestCase {

    func testAsdf() {
        let text1 = "abcdef"
        let text2 = "zzcdzz"
        
        print(text1.difference(from: text2))
    }
    
    func test_showDiff호출하면_차이나는글자빨간색으로표시() {
        //given
        let viewModel = DiffTextViewModel()
        let mockView = MockView(viewModel: viewModel)
        viewModel.view = mockView
        
        
        //when
        viewModel.showDiffString(srcText: "nice job!", targetText: "good job!")
        
        //then
        let diff = try! mockView.diffString.value()
        let diff1 = diff.attributedSubstring(from: NSRange(location: 0, length: 4))
        let diff2 = diff.attributedSubstring(from: NSRange(location: 4, length: 5))
        
        //good 은 nice 랑 다르므로 빨간색
        XCTAssertEqual("good", diff1.string)
        var effectiveRange = NSRange(location: 0, length: 0)
        XCTAssertEqual(UIColor.systemRed, diff1.attribute(.foregroundColor, at: 0, effectiveRange: &effectiveRange) as! UIColor)
        XCTAssertEqual(4, effectiveRange.length)
        
        //job 은 같으므로 초록색
        XCTAssertEqual(" job!", diff2.string)
        XCTAssertEqual(UIColor.systemGreen, diff2.attribute(.foregroundColor, at: 0, effectiveRange: &effectiveRange) as! UIColor)
        XCTAssertEqual(5, effectiveRange.length)
    }
    
    
    class MockView: DiffTextViewProtocol {
        func showDiff(srcText: String, targetText: String) {
            fatalError()
        }
        
        var diffString: BehaviorSubject<NSAttributedString> = BehaviorSubject(value: NSAttributedString())
        var viewModel: DiffTextViewModelProtocol
        
        init (viewModel: DiffTextViewModelProtocol) {
            self.viewModel = viewModel
        }
    }
}
