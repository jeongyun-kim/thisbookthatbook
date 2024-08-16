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
    
    func fetchData<T: Decodable>(model: T.Type, request: URLRequest, completionHandler: @escaping (Int?, T?) -> Void){
        AF.request(request).responseDecodable(of: model) { response in
            let statusCode = response.response?.statusCode
            switch response.result {
            case .success(let value):
                completionHandler(statusCode, value)
            case .failure(let error):
                completionHandler(statusCode, nil)
            }
        }
    }
}

// MARK: AuthorizationRouter
extension NetworkService {
    func postUserLogin(email: String, password: String) -> Single<Result<Login, ErrorCase.LoginError>> {
        return Single.create { [weak self] single -> Disposable in
            let query = LoginQuery(email: email, password: password)
            do {
                let request = try AuthorizationRouter.login(query: query).asURLRequest()
                self?.fetchData(model: Login.self, request: request) { statusCode, value in
                    guard let statusCode else { return }
                    switch statusCode {
                    case 200:
                        guard let value else { return }
                        single(.success(.success(value)))
                    case 400:
                        single(.success(.failure(.emptyData)))
                    case 401:
                        single(.success(.failure(.invalidData)))
                    default:
                        single(.success(.failure(.defaultError)))
                    }
                }
            } catch {
                print("post user request error")
            }
            return Disposables.create()
        }
    }
    
    func getRefreshToken(completionHandler: @escaping (ErrorCase.RefreshTokenError) -> Void) {
        do {
            let request = try AuthorizationRouter.refreshToken.asURLRequest()
            self.fetchData(model: RefreshToken.self, request: request) { statusCode, value in
                guard let statusCode else { return }
                switch statusCode {
                case 200:
                    guard let value else { return }
                    UserDefaultsManager.shared.accessToken = value.accessToken
                case 401:
                    completionHandler(.invalidToken)
                case 403:
                    completionHandler(.forbidden)
                case 418:
                    completionHandler(.expiredToken)
                default:
                    completionHandler(.defaultError)
                }
            }
        } catch {
            print("get refreshToken request error")
        }
    }
    
    func postSignUp(email: String, password: String, nickname: String) -> Single<Result<Signup, ErrorCase.SignupError>> {
        return Single.create { [weak self] single -> Disposable in
            do {
                let query = SignupQuery(email: email, password: password, nick: nickname)
                let request = try AuthorizationRouter.singUp(query: query).asURLRequest()
                self?.fetchData(model: Signup.self, request: request) { statusCode, value in
                    guard let statusCode else { return }
                    switch statusCode {
                    case 200:
                        guard let value else { return }
                        single(.success(.success(value)))
                    case 409: single(.success(.failure(.existUser)))
                    default: single(.success(.failure(.defaultError)))
                    }
                }
            } catch {
                print("post signup request error")
            }
            return Disposables.create()
        }
    }
    
    func postValidateEmail(email: String) -> Single<Result<EmailValidation, ErrorCase.EmailValidationError>> {
        return Single.create { [weak self] single -> Disposable in
            do {
                let query = EmailQuery(email: email)
                let request = try AuthorizationRouter.validateEmail(query: query).asURLRequest()
                self?.fetchData(model: EmailValidation.self, request: request) { statusCode, value in
                    guard let statusCode else { return }
                    switch statusCode {
                    case 200:
                        guard let value else { return }
                        single(.success(.success(value)))
                    case 409: single(.success(.failure(.invalidEmail)))
                    default: break
                    }
                }
                
            } catch {
                print("validate email request error")
            }
            return Disposables.create()
        }
    }
    
    func getWithDraw() -> Single<Result<Withdraw, ErrorCase.RefreshTokenError>>{
        return Single.create { [weak self] single -> Disposable in
            do {
                let request = try AuthorizationRouter.withdraw.asURLRequest()
                self?.fetchData(model: Withdraw.self, request: request) { statusCode, value in
                    guard let statusCode else { return }
                    switch statusCode {
                    case 200:
                        guard let value else { return }
                        single(.success(.success(value)))
                    case 419: self?.getRefreshToken { error in
                        single(.success(.failure(error)))
                    }
                    default: single(.success(.failure(.defaultError)))
                    }
                    
                }
            } catch {
                print("withdraw request error")
            }
            return Disposables.create()
        }
    }
}
