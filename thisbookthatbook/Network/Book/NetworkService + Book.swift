//
//  NetworkService + Book.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/21/24.
//

import Foundation
import Alamofire
import RxSwift

extension NetworkService {
    func fetchBooks(query: String, start: Int = 1) -> Single<Result<BookSearchResult, AFError>> {
        return Single.create { single -> Disposable in
            do {
                let query = BookSearchQuery(query: query, start: start)
                let request = try BookRouter.search(query: query).asURLRequest()
                AF.request(request).responseDecodable(of: BookSearchResult.self) { response in
                    switch response.result {
                    case .success(let value):
                        single(.success(.success(value)))
                    case .failure(let error):
                        single(.success(.failure(error)))
                    }
                }
            } catch {
                print("book request error")
            }
            return Disposables.create()
        }
    }
}
