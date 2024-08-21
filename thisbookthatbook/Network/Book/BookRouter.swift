//
//  BookRouter.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/21/24.
//

import Alamofire
import Foundation

enum BookRouter: TargetType {
    case search(query: BookSearchQuery)
    
    var baseURL: String {
        return BookAPI.bookBaseURL
    }
    
    var endPoint: String {
        return "v1/search/book.json"
    }
    
    var header: [String : String] {
        return [BookAPI.Headers.clientId: BookAPI.clientId, BookAPI.Headers.clientSecret: BookAPI.key]
    }
    
    var method: Alamofire.HTTPMethod {
        return .get
    }
    
    var body: Data? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .search(let query):
            return [URLQueryItem(name: "query", value: query.query), URLQueryItem(name: "start", value: "\(query.start)")]
        }
    }
}
