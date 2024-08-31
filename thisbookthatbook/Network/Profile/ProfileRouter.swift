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
    case followUser(userId: String)
    case unfollowUser(userId: String)
}

extension ProfileRouter: TargetType {
    var baseURL: String {
        return API.baseURL
    }
    
    var endPoint: String {
        switch self {
        case .getMyProfile:
            return "v1/users/me/profile"
        case .followUser(let userId):
            return "v1/follow/\(userId)"
        case .unfollowUser(let userId):
            return "v1/follow/\(userId)"
        }
    }
    
    var header: [String : String] {
        let accessToken = UserDefaultsManager.shared.accessToken
        switch self {
        case .getMyProfile:
            return [API.Headers.auth: accessToken, API.Headers.sesacKey: API.key]
        case .followUser:
            return [API.Headers.auth: accessToken, API.Headers.sesacKey: API.key]
        case .unfollowUser:
            return [API.Headers.auth: accessToken, API.Headers.sesacKey: API.key]
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getMyProfile:
            return .get
        case .followUser:
            return .post
        case .unfollowUser:
            return .delete
        }
    }
    
    var body: Data? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
}
