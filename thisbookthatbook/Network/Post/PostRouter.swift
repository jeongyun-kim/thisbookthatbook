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
    case deletePost(query: String)
    case likePost(query: LikeQuery, id: String)
    case getPostData(id: String)
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
        case .deletePost(let postId):
            return "v1/posts/\(postId)"
        case .likePost(_, let postId):
            return "v1/posts/\(postId)/like"
        case .getPostData(let postId):
            return "v1/posts/\(postId)"
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
        case .likePost:
            return [API.Headers.auth: accessToken, API.Headers.sesacKey: API.key, API.Headers.contentKey: API.Headers.jsonValue]
        case .getPostData:
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
        case .likePost:
            return .post
        case .getPostData:
            return .get
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
        case .likePost(let query, _):
            return encoding(query)
        case .getPostData:
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
        case .deletePost:
            return nil
        case .likePost:
            return nil
        case .getPostData:
            return nil
        }
    }
}
