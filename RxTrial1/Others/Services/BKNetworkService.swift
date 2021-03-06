//
//  NetworkService.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/06/26.
//

import Foundation
import Alamofire
import RxSwift

protocol NetworkServiceProtocol {
    func execute<T: Decodable>(
        _ url: String,
        method: String,
        params: [String: String],
        headers: [String: String]
    ) -> Observable<T>

    func executeData(
        _ url: String,
        method: String,
        params: [String: String],
        headers: [String: String]
    ) -> Observable<Data>
}

class BKNetworkService: NetworkServiceProtocol {
    
    func execute<T: Decodable>(
        _ url: String,
        method: String,
        params: [String: String],
        headers: [String: String]
    ) -> Observable<T> {
        
        return Observable<T>.create { observer in
            let dataTask = AF.request(
                    url,
                    method: HTTPMethod(rawValue: method),
                    parameters: params,
                    headers: HTTPHeaders(headers))
                    .responseDecodable(of: T.self) { result in
                        switch result.result {
                        case .success(let value):
                            observer.onNext(value)
                        case .failure(let error):
                            observer.onError(error)
                        }

                        observer.onCompleted()
                    }
            
            return Disposables.create {
                dataTask.cancel()
            }
        }
    }

    func executeData(
        _ url: String,
        method: String,
        params: [String: String],
        headers: [String: String]
    ) -> Observable<Data> {
        Observable.create { observer -> Disposable in
            let dataTask = AF.request(
                    url,
                    method: HTTPMethod(rawValue: method),
                    parameters: params,
                    headers: HTTPHeaders(headers))
                    .responseData { (result: AFDataResponse<Data>) in
                        switch result.result {
                        case .success(let value):
                            observer.onNext(value)
                        case .failure(let error):
                            observer.onError(error)
                        }

                        observer.onCompleted()
                    }

            return Disposables.create {
                dataTask.cancel()
            }
        }
    }
}
