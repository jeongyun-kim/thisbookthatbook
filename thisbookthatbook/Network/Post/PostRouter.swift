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
    case postLikePost(query: LikeQuery, id: String)
    case postBookmarkPost(query: BookmarkQuery, id: String)
    case getPostData(id: String)
    case postComment(query: CommentQuery, id: String)
    case deleteComment(postId: String, commentId: String)
    case getSearchHashtag(query: SearchQuery)
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
        case .postLikePost(_, let postId):
            return "v1/posts/\(postId)/like"
        case .getPostData(let postId):
            return "v1/posts/\(postId)"
        case .postComment(_, let id):
            return "v1/posts/\(id)/comments"
        case .postBookmarkPost(_, let postId):
            return "v1/posts/\(postId)/like-2"
        case .deleteComment(let postId, let commentId):
            return "v1/posts/\(postId)/comments/\(commentId)"
        case .getSearchHashtag:
            return "v1/posts/hashtags"
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
        case .postLikePost:
            return [API.Headers.auth: accessToken, API.Headers.sesacKey: API.key, API.Headers.contentKey: API.Headers.jsonValue]
        case .getPostData:
            return [API.Headers.auth: accessToken, API.Headers.sesacKey: API.key]
        case .postComment:
            return [API.Headers.auth: accessToken, API.Headers.contentKey: API.Headers.jsonValue, API.Headers.sesacKey: API.key]
        case .postBookmarkPost:
            return [API.Headers.auth: accessToken, API.Headers.sesacKey: API.key, API.Headers.contentKey: API.Headers.jsonValue]
        case .deleteComment:
            return [API.Headers.auth: accessToken, API.Headers.sesacKey: API.key]
        case .getSearchHashtag:
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
        case .postLikePost:
            return .post
        case .getPostData:
            return .get
        case .postComment:
            return .post
        case .postBookmarkPost:
            return .post
        case .deleteComment:
            return .delete
        case .getSearchHashtag:
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
        case .postLikePost(let query, _):
            return encoding(query)
        case .getPostData:
            return nil
        case .postComment(let query, _):
            return encoding(query)
        case .postBookmarkPost(let query, _):
            return encoding(query)
        case .deleteComment:
            return nil
        case .getSearchHashtag:
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
            return [URLQueryItem(name: "limit", value: "10"), URLQueryItem(name: "next", value: query.next), URLQueryItem(name: "product_id", value: query.product_id)]
        case .deletePost:
            return nil
        case .postLikePost:
            return nil
        case .getPostData:
            return nil
        case .postComment:
            return nil
        case .postBookmarkPost:
            return nil
        case .deleteComment:
            return nil
        case .getSearchHashtag(let query):
            return [URLQueryItem(name: "limit", value: "10"), URLQueryItem(name: "next", value: query.next), URLQueryItem(name: "hashTag", value: query.hashTag)]
        }
    }
}
