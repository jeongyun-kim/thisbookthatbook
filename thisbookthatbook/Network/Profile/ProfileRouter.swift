//
//  ProfileRouter.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/26/24.
//

import Foundation
import Alamofire

enum ProfileRouter {
    case getMyProfile
}

extension ProfileRouter: TargetType {
    var baseURL: String {
        return API.baseURL
    }
    
    var endPoint: String {
        switch self {
        case .getMyProfile:
            return "v1/users/me/profile"
        }
    }
    
    var header: [String : String] {
        let accessToken = UserDefaultsManager.shared.accessToken
        switch self {
        case .getMyProfile:
            return [API.Headers.auth: accessToken, API.Headers.sesacKey: API.key]
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getMyProfile:
            return .get
        }
    }
    
    var body: Data? {
        switch self {
        case .getMyProfile:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .getMyProfile:
            return nil
        }
    }
    
    
}
