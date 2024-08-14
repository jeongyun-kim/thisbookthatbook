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
    
    private func encoding<T: Encodable>(_ data: T) -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(data)
    }
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
        }
    }
    
    var header: [String : String] {
        switch self {
        case .login:
            return [API.Headers.contentKey: API.Headers.jsonValue, API.Headers.sesacKey: API.key]
        case .validateEmail:
            return [API.Headers.contentKey: API.Headers.jsonValue, API.Headers.sesacKey: API.key]
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .login:
            return .post
        case .validateEmail:
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
        }
    }
}
    
