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
    
    func fetchData<T: Decodable>(model: T.Type, request: URLRequest, completionHandler: @escaping (T?, Int?) -> Void){
        AF.request(request).responseDecodable(of: model) { response in
            switch response.result {
            case .success(let value):
                completionHandler(value, nil)
            case .failure(_):
                completionHandler(nil, response.response?.statusCode)
                }
            }
        }
        
    func postUserLogin(email: String, password: String) -> Single<Result<Login, ErrorCase.LoginError>> {
        return Single.create { single -> Disposable in
            let query = LoginQuery(email: email, password: password)
            do {
                let request = try AuthorizationRouter.login(query: query).asURLRequest()
                self.fetchData(model: Login.self, request: request) { value, statusCode in
                    if let statusCode {
                        switch statusCode {
                        case 400: single(.success(.failure(.emptyData)))
                        case 401: single(.success(.failure(.invalidData)))
                        default: break
                        }
                    }
                    
                    guard let value else { return }
                    single(.success(.success(value)))
                }
            } catch {
                print("post user request error")
            }
            return Disposables.create()
        }
    }
    
    func getRefreshToken(completionHandler: @escaping (Result<RefreshToken, ErrorCase.RefreshTokenError>) -> Void) {
        do {
            let request = try AuthorizationRouter.refreshToken.asURLRequest()
            self.fetchData(model: RefreshToken.self, request: request) { value, statusCode in
                if let statusCode {
                    switch statusCode {
                    case 401: completionHandler(.failure(.invalidToken))
                    case 403: completionHandler(.failure(.forbidden))
                    case 418: completionHandler(.failure(.expiredToken))
                    default: break
                    }
                }
                
                guard let value else { return }
                completionHandler(.success(value))
            }
        } catch {
            print("get refreshToken request error")
        }
    }

    func postSignUp(email: String, password: String, nickname: String) -> Single<Result<Signup, ErrorCase.SignupError>> {
        return Single.create { single -> Disposable in
            do {
                let query = SignupQuery(email: email, password: password, nick: nickname)
                let request = try AuthorizationRouter.singUp(query: query).asURLRequest()
                self.fetchData(model: Signup.self, request: request) { value, statusCode in
                    if let statusCode {
                        switch statusCode {
                        case 400: single(.success(.failure(.emptyData)))
                        case 409: single(.success(.failure(.existUser)))
                        default: break
                        }
                    }
                    
                    guard let value else { return }
                    single(.success(.success(value)))
                }
            } catch {
                print("post signup request error")
            }
            return Disposables.create()
        }
    }
    
    func validateEmail(email: String) -> Single<Result<EmailValidation, ErrorCase.EmailValidationError>> {
        return Single.create { single -> Disposable in
            do {
                let query = EmailQuery(email: email)
                let request = try AuthorizationRouter.validateEmail(query: query).asURLRequest()
                self.fetchData(model: EmailValidation.self, request: request) { value, statusCode in
                    if let statusCode {
                        switch statusCode {
                        case 400: single(.success(.failure(.emptyEmail)))
                        case 409: single(.success(.failure(.invalidEmail)))
                        default: break
                        }
                    }
                    
                    guard let value else { return }
                    single(.success(.success(value)))
                }
            } catch {
                print("validate email request error")
            }
            return Disposables.create()
        }
    }
}
