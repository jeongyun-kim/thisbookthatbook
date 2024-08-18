//
//  AuthInterceptor.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/18/24.
//

import Foundation
import Alamofire

final class AuthInterceptor:  RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        print(#function)
        var request = urlRequest
        let ud = UserDefaultsManager.shared
        
        request.setValue(ud.accessToken, forHTTPHeaderField: API.Headers.auth)
        request.setValue(ud.refreshToken, forHTTPHeaderField: API.Headers.refresh)
        request.setValue(API.key, forHTTPHeaderField: API.Headers.sesacKey)
        
        completion(.success(request))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        guard let statusCode = request.response?.statusCode, statusCode == 419 else {
            completion(.doNotRetry)
            return
        }
        
        NetworkService.shared.getRefreshToken { result in
            switch result {
            case .success(let value):
                UserDefaultsManager.shared.accessToken = value.accessToken
                completion(.retry)
            case .failure(let error):
                completion(.doNotRetryWithError(error))
            }
        }
    }
}
