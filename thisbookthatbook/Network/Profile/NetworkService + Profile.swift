//
//  NetworkService + Profile.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/26/24.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

extension NetworkService {
    func getMyProfile() -> Single<Result<UserProfile, Errors>> {
        return Single.create { single -> Disposable in
            
            do {
                let request = try ProfileRouter.getMyProfile.asURLRequest()
                self.fetchData(model: UserProfile.self, request: request) { statusCode, value in
                    guard let statusCode else { return }
                    switch statusCode {
                    case 200:
                        guard let value else { return }
                        single(.success(.success(value)))
                    case 419:
                        single(.success(.failure(.expiredToken)))
                    default:
                        single(.success(.failure(.defaultError)))
                    }
                    
                }
            } catch {
                print("get my profile request error")
            }
            
            return Disposables.create()
        }
        
    }
}
