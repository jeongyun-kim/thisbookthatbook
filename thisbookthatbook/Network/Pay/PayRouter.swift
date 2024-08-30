//
//  PayRouter.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/30/24.
//

import Foundation
import Alamofire

enum PayRouter {
    case postValidateReciept(query: PayQuery)
}

extension PayRouter: TargetType {
    var baseURL: String {
        return API.baseURL
    }
    
    var endPoint: String {
        switch self {
        case .postValidateReciept(let query):
            return "v1/payments/validation"
        }
    }
    
    var header: [String : String] {
        let accessToken = UserDefaultsManager.shared.accessToken
        switch self {
        case .postValidateReciept:
            return [API.Headers.auth: accessToken, API.Headers.sesacKey: API.key, API.Headers.contentKey: API.Headers.jsonValue]
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .postValidateReciept(let query):
            return .post
        }
    }
    
    var body: Data? {
        switch self {
        case .postValidateReciept(let query):
            return encoding(query)
        }
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    
}
