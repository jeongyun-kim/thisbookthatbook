//
//  TargetType.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/14/24.
//

import Foundation
import Alamofire

protocol TargetType: URLRequestConvertible {
    var baseURL: String { get }
    var endPoint: String { get }
    var header: [String: String] { get }
    var method: HTTPMethod { get }
    var body: Data? { get }
    var queryItems: [URLQueryItem]? { get }
}

extension TargetType {
    func asURLRequest() throws -> URLRequest {
        let baseURL = try baseURL.asURL()
        let endPoint = baseURL.appendingPathComponent(endPoint)
        var request = try URLRequest(url: endPoint, method: method)
        request.allHTTPHeaderFields = header
        request.httpBody = body
        guard let queryItems else { return request }
        request.url?.append(queryItems: queryItems)
        return request
    }
    
    func encoding<T: Encodable>(_ data: T) -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(data)
    }
}
