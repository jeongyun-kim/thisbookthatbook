//
//  PostRouter.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/16/24.
//

import Foundation
import Alamofire

enum PostRouter {
    case uploadImage
    case uploadPost(query: UploadPostQuery)
    case getPosts(query: GetPostsQuery)
    case deletePost(query: PostIdQuery)
}

extension PostRouter: TargetType {
    var baseURL: String {
        return API.baseURL
    }
    
    var endPoint: String {
        switch self {
        case .uploadImage:
            return "v1/posts/files"
        case .uploadPost:
            return "v1/posts"
        case .getPosts:
            return "v1/posts"
        case .deletePost(let query):
            return "v1/posts/\(query.id)"
        }
    }
    
    var header: [String : String] {
        let accessToken = UserDefaultsManager.shared.accessToken
        switch self {
        case .uploadImage:
            return [API.Headers.auth: accessToken, API.Headers.contentKey: API.Headers.dataValue, API.Headers.sesacKey: API.key]
        case .uploadPost:
            return [API.Headers.auth: accessToken, API.Headers.contentKey: API.Headers.jsonValue, API.Headers.sesacKey: API.key]
        case .getPosts:
            return [API.Headers.auth: accessToken, API.Headers.sesacKey: API.key]
        case .deletePost:
            return [API.Headers.auth: accessToken, API.Headers.sesacKey: API.key]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .uploadImage:
            return .post
        case .uploadPost:
            return .post
        case .getPosts:
            return .get
        case .deletePost:
            return .delete
        }
    }
    
    var body: Data? {
        switch self {
        case .uploadImage:
           return nil
        case .uploadPost(let query):
            return encoding(query)
        case .getPosts:
            return nil
        case .deletePost:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .uploadImage:
            return nil
        case .uploadPost:
            return nil
        case .getPosts(let query):
            return [URLQueryItem(name: "limit", value: "5"), URLQueryItem(name: "next", value: query.next), URLQueryItem(name: "product_id", value: query.product_id)]
        case .deletePost(let query):
            return nil
        }
    }
}
