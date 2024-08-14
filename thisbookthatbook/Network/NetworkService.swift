//
//  NetworkService.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/13/24.
//

import Foundation
import Alamofire
import RxSwift

final class NetworkService {
    static let shared = NetworkService()
    private init() {}
        
    func postUserLogin<T: Decodable>(model: T.Type, email: String, password: String) -> Single<Result<T, ErrorCase.LoginError>> {
        return Single.create { single -> Disposable in
            let query = LoginQuery(email: email, password: password)
            do {
                let request = try AuthorizationRouter.login(query: query).asURLRequest()
                AF.request(request).responseDecodable(of: model.self) { response in
                    switch response.result {
                    case .success(let value):
                        single(.success(.success(value)))
                    case .failure(let error):
                        switch response.response?.statusCode {
                        case 400: single(.success(.failure(.emptyData)))
                        case 401: single(.success(.failure(.invalidData)))
                        default: break
                        }
                    }
                }
            } catch {
                print("post user request error")
            }
            return Disposables.create()
        }
    }
    
    
    
  
}
