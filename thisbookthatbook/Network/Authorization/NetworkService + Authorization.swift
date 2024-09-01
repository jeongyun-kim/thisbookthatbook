//
//  NetworkService + Authorization.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/16/24.
//

import Foundation
import Alamofire
import RxSwift

extension NetworkService {
    func postUserLogin(email: String, password: String) -> Single<Result<Login, Errors>> {
        return Single.create { [weak self] single -> Disposable in
            let query = LoginQuery(email: email, password: password)
            do {
                let request = try AuthorizationRouter.login(query: query).asURLRequest()
                self?.fetchData(model: Login.self, request: request) { statusCode, value in
                    guard let statusCode else { return }
                    switch statusCode {
                    case 200:
                        guard let value else { return }
                        UserDefaultsManager.shared.accessToken = value.accessToken
                        UserDefaultsManager.shared.refreshToken = value.refreshToken
                        UserDefaultsManager.shared.id = value.id
                        single(.success(.success(value)))
                    case 400:
                        single(.success(.failure(.loginEmptyData)))
                    case 401:
                        single(.success(.failure(.loginInvalidData)))
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
    
    func getRefreshToken(completionHandler: @escaping (Result<RefreshToken, Errors>) -> Void) {
        do {
            let request = try AuthorizationRouter.refreshToken.asURLRequest()
           
            fetchData(model: RefreshToken.self, request: request) { statusCode, value in
                guard let statusCode else { return }
                switch statusCode {
                case 200:
                    guard let value else { return }
                    completionHandler(.success(value))
                case 418:
                    completionHandler(.failure(.expiredToken))
                default:
                    completionHandler(.failure(.defaultError))
                }
            }
        } catch {
            print("get refreshToken request error")
        }
    }
    
    func postSignUp(email: String, password: String, nickname: String) -> Single<Result<Signup, Errors>> {
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
                    case 409: 
                        single(.success(.failure(.signupExistUser)))
                    default: 
                        single(.success(.failure(.defaultError)))
                    }
                }
            } catch {
                print("post signup request error")
            }
            return Disposables.create()
        }
    }
    
    func postValidateEmail(email: String) -> Single<Result<EmailValidation, Errors>> {
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
                    case 409: 
                        single(.success(.failure(.signupInvalidEmail)))
                    default: 
                        single(.success(.failure(.defaultError)))
                    }
                }
            } catch {
                print("validate email request error")
            }
            return Disposables.create()
        }
    }
    
    func getWithDraw() -> Single<Result<Withdraw, Errors>>{
        return Single.create { [weak self] single -> Disposable in
            do {
                let request = try AuthorizationRouter.withdraw.asURLRequest()
                self?.fetchData(model: Withdraw.self, request: request) { statusCode, value in
                    guard let statusCode else { return }
                    switch statusCode {
                    case 200:
                        guard let value else { return }
                        UserDefaultsManager.shared.deleteAllData()
                        single(.success(.success(value)))
                    case 419:
                        single(.success(.failure(.expiredToken)))
                    default: 
                        single(.success(.failure(.defaultError)))
                    }
                }
            } catch {
                print("withdraw request error")
            }
            return Disposables.create()
        }
    }
    
    func putEditProfile(profileImage: Data?, nickname: String) -> Single<Result<Void, Errors>> {
        return Single.create { single -> Disposable in
            do {
                let request = try AuthorizationRouter.editProfile.asURLRequest()
                
                AF.upload(multipartFormData: { multipartFormData in
                    guard let nick = nickname.data(using: .utf8) else { return }
                    multipartFormData.append(nick, withName: "nick", mimeType: "text/plain")
                    if let profileImage {
                        let id = UserDefaultsManager.shared.id
                        multipartFormData.append(profileImage, withName: "profile", fileName: "profile_\(id).png", mimeType: "image/png")
                    }
                }, with: request).responseDecodable(of: UserProfile.self) { response in
                    guard let statusCode = response.response?.statusCode else { return }
                    switch statusCode {
                    case 200:
                        single(.success(.success(())))
                    case 409:
                        single(.success(.failure(.existNickname)))
                    case 419:
                        single(.success(.failure(.expiredToken)))
                    default:
                        single(.success(.failure(.defaultError)))
                    }
                }
            } catch {
                print("edit profile request error")
            }
            
            return Disposables.create()
        }
    }
}
