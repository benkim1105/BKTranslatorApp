//
//  BKRemoteFileService.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/07/04.
//

import Foundation
import RxSwift
import UIKit

protocol BKRemoteFileServiceProtocol {
    ///이미지를 서버에 저장한다.
    func saveImageFile(image: UIImage?, name: String, quality: CGFloat) -> Observable<RemoteImage?>
}

///원격에 파일 저장. 지금은 원격서버가 없으니까 그냥 document 에 저장한다.
class BKRemoteFileService: BKRemoteFileServiceProtocol {
    private var fileService: BKLocalFileServiceProtocol
    
    init(fileService: BKLocalFileServiceProtocol) {
        self.fileService = fileService
    }
    
    func saveImageFile(image: UIImage?, name: String, quality: CGFloat = 0.7) -> Observable<RemoteImage?> {
        
        Observable.create { [weak self] observer -> Disposable in
            guard let data = image?.jpegData(compressionQuality: quality) else {
                return Disposables.create()
            }
            
            _ = self?.fileService.saveFile(type: .cover, data: data, name: name)
            observer.onNext(RemoteImage(name: name, width: Int(image?.size.width ?? 0), height: Int(image?.size.height ?? 0), isLocal: true))
            
            observer.onCompleted()
            return Disposables.create()
        }
    }
}
