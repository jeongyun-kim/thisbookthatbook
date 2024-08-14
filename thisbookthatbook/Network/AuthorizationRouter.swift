//
//  AuthorizationRouter.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/13/24.
//

import Foundation
import Alamofire

enum AuthorizationRouter {
    case login(query: LoginQuery)
    case validateEmail(email: String)
    case refreshToken
    case singUp(query: SignupQuery)
}

extension AuthorizationRouter: TargetType {
    var baseURL: String {
        return API.baseURL
    }
    
    var endPoint: String {
        switch self {
        case .login:
            return "v1/users/login"
        case .validateEmail:
            return "v1/validation/email"
        case .refreshToken:
            return "v1/auth/refresh"
        case .singUp:
            return "v1/users/join"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .login:
            return [API.Headers.contentKey: API.Headers.jsonValue, API.Headers.sesacKey: API.key]
        case .validateEmail:
            return [API.Headers.contentKey: API.Headers.jsonValue, API.Headers.sesacKey: API.key]
        case .refreshToken:
            let accessToken = UserDefaultsManager.shared.accessToken
            let refreshToken = UserDefaultsManager.shared.refreshToken
            return [API.Headers.auth: accessToken, API.Headers.sesacKey: API.key, API.Headers.refresh: refreshToken]
        case .singUp:
            return [API.Headers.contentKey: API.Headers.jsonValue, API.Headers.sesacKey: API.key]
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .login:
            return .post
        case .validateEmail:
            return .post
        case .refreshToken:
            return .get
        case .singUp:
            return .post
        }
    }
    
    var body: Data? {
        switch self {
        case .login(let query):
            // JSON으로 인코딩 해주기위해 인코더 생성
            return encoding(query)
        case .validateEmail(let email):
            return encoding(["email": email])
        case .refreshToken:
            return nil
        case .singUp(let query):
            return encoding(query)
        }
    }
}
    
