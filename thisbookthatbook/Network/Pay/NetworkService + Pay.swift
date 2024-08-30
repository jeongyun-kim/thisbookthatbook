//
//  NetworkService + Pay.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/30/24.
//

import Foundation
import RxSwift

extension NetworkService {
    func postValidateReciept(query: PayQuery) -> Single<Result<Reciept, Errors>> {
        return Single.create { single -> Disposable in
            do {
                let request = try PayRouter.postValidateReciept(query: query).asURLRequest()
                
                self.fetchData(model: Reciept.self, request: request) { statusCode, value in
                    guard let statusCode else { return }
                    switch statusCode {
                    case 200:
                        guard let value else { return }
                        single(.success(.success(value)))
                    case 400:
                        single(.success(.failure(.invalidPayRequest)))
                    case 410:
                        single(.success(.failure(.noPostToPay)))
                    case 419:
                        single(.success(.failure(.expiredToken)))
                    default:
                        single(.success(.failure(.defaultError)))
                    }
                }
            } catch {
                print("pay post request error")
            }
            return Disposables.create()
        }
    }
}
