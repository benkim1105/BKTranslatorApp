//
//  BKSaveViewModelTest.swift
//  RxTrial1Tests
//
//  Created by Ben KIM on 2022/06/29.
//

import XCTest
@testable import RxTrial1


class BKSaveViewModelTest: XCTestCase {
    func test_저장하기누르면_View에로딩띄우고_각Sentnece의발음base64받아오고_Data저장() {
        //given
        let sentences = [Sentence(script: "안녕", translation: "hello", scriptLanguage: .ko, translationLanguage: .en)]
        let viewModel = BKSaveViewModel(sentences: sentences)
        
        //when
        viewModel.save(title: "title", image: nil)
        
        //then
        
    }
}
