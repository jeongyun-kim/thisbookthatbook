//
//  NetworkService.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/13/24.
//

import Foundation
import Alamofire

final class NetworkService {
    static let shared = NetworkService()
    private init() {}
    
    // 추후에 statusCode에 따라 에러 케이스를 던져줘서 처리해보기
    func fetchData<T: Decodable>(model: T.Type, request: URLRequest, completionHandler: @escaping (Int?, T?) -> Void){
        AF.request(request, interceptor: AuthInterceptor.interceptor).responseDecodable(of: model) { response in
            let statusCode = response.response?.statusCode
            switch response.result {
            case .success(let value):
                completionHandler(statusCode, value)
            case .failure(_):
                completionHandler(statusCode, nil)
            }
        }
    }
}
