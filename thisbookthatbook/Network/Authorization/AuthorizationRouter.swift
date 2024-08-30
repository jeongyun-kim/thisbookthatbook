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
    case validateEmail(query: EmailQuery)
    case refreshToken
    case singUp(query: SignupQuery)
    case withdraw
    case editProfile
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
        case .withdraw:
            return "v1/users/withdraw"
        case .editProfile:
            return "v1/users/me/profile"
        }
    }
    
    var header: [String : String] {
        let accessToken = UserDefaultsManager.shared.accessToken
        let refreshToken = UserDefaultsManager.shared.refreshToken
        switch self {
        case .login:
            return [API.Headers.contentKey: API.Headers.jsonValue, API.Headers.sesacKey: API.key]
        case .validateEmail:
            return [API.Headers.contentKey: API.Headers.jsonValue, API.Headers.sesacKey: API.key]
        case .refreshToken:
            return [API.Headers.auth: accessToken, API.Headers.sesacKey: API.key, API.Headers.refresh: refreshToken]
        case .singUp:
            return [API.Headers.contentKey: API.Headers.jsonValue, API.Headers.sesacKey: API.key]
        case .withdraw:
            return [API.Headers.auth: accessToken, API.Headers.sesacKey: API.key]
        case .editProfile:
            return [API.Headers.auth: accessToken, API.Headers.contentKey: API.Headers.dataValue, API.Headers.sesacKey: API.key]
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
        case .withdraw:
            return .get
        case .editProfile:
            return .put
        }
    }
    
    var body: Data? {
        switch self {
        case .login(let query):
            return encoding(query)
        case .validateEmail(let query):
            return encoding(query)
        case .refreshToken:
            return nil
        case .singUp(let query):
            return encoding(query)
        case .withdraw:
            return nil
        case .editProfile:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
}
    
