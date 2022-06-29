//
//  MetaTranslation.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/06/27.
//

import Foundation

///번역 결과를 다시 번역한 것
///번역이 맞는지 확인하는 용도로 한->영, 번역을 다시 영->한 으로  번역한다.
struct MetaTranslation {
    let engine: Engine?
    let translation: Translation
    let metaTranslation: Translation
}

