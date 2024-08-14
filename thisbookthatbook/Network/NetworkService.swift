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
        
    func postUserLogin<T: Decodable>(model: T.Type, email: String, password: String) -> Single<Result<T, Error>> {
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
                        case 400: single(.success(.failure(ErrorCase.LoginError.emptyData)))
                        case 401: single(.success(.failure(ErrorCase.LoginError.invalidData)))
                        case 420, 429, 444, 500: single(.success(.failure(ErrorCase.defaultError)))
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
    
    func refreshToken(completionHandler: @escaping (Result<RefreshToken, Error>) -> Void) {
        do {
            let request = try AuthorizationRouter.refreshToken.asURLRequest()
            AF.request(request).responseDecodable(of: RefreshToken.self) { response in
                switch response.result {
                case .success(let value):
                    completionHandler(.success(value))
                case .failure(let error):
                    switch response.response?.statusCode {
                    case 401: completionHandler(.failure(ErrorCase.RefreshTokenError.invalidToken))
                    case 403: completionHandler(.failure(ErrorCase.RefreshTokenError.forbidden))
                    case 418: completionHandler(.failure(ErrorCase.RefreshTokenError.expiredToken))
                    case 420, 429, 444, 500: completionHandler(.failure(ErrorCase.defaultError))
                    default: break
                    }
                }
            }
        } catch {
            print("get refreshToken request error")
        }
    }
}
