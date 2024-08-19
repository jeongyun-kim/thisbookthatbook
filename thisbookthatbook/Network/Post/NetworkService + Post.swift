//
//  NetworkService + Post.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/16/24.
//

import Foundation
import Alamofire
import RxSwift

extension NetworkService {
    func postImages(query: UploadPostQuery, files: [FilesQuery], completionHandler: @escaping (Errors?) -> Void){
        
        do {
            let request = try PostRouter.uploadImage.asURLRequest()
            AF.upload(multipartFormData: { multiPartFormData in
                for file in files {
                    guard let image = file.image else { continue }
                    multiPartFormData.append(image, withName: "files", fileName: file.imageName+".png", mimeType: "image/png")
                }
            }, with: request).responseDecodable(of: Files.self) { response in
                let statusCode = response.response?.statusCode

                switch response.result {
                case .success(let value):
                    switch statusCode {
                    case 200:
                        var query = query
                        query.files = value.files
                        self.postPosts(query: query)
                    case 419:
                        completionHandler(.expiredToken)
                    default:
                        completionHandler(Errors.defaultError)
                    }
                case .failure(_):
                    completionHandler(Errors.defaultError)
                }
            }
        } catch {
            print("post image request error")
        }
    }
    
    func postPosts(query: UploadPostQuery) {
        do {
            let request = try PostRouter.uploadPost(query: query).asURLRequest()
            fetchData(model: Posts.self, request: request) { statusCode, value in
                guard let statusCode else { return }
                switch statusCode {
                case 200:
                    guard let value else { return }
                    print(#function, value)
                case 410:
                    print("생성된 게시글 없음")
                default:
                    print(Errors.defaultError.rawValue.localized)
                }
            }
        } catch {
            print("posts upload reqeust error")
        }
    }
    
    func getPosts(query: GetPostsQuery) -> Single<Result<[Post], Errors>> {
        return Single.create { [weak self] single -> Disposable in
            do {
                let request = try PostRouter.getPosts(query: query).asURLRequest()
                self?.fetchData(model: Posts.self, request: request) { statusCode, value in
                    switch statusCode {
                    case 200:
                        guard let value else { return }
                        single(.success(.success(value.data)))
                    case 419:
                        // 만약 토큰이 갱신되지 않았다면 retry에서 에러를 전달하고 상태코드 419인 상태에서 에러가 발생한 것으로 처리됨
                        // -> 그러므로 리프레시 토큰이 만료되었다는 에러메시지 전달
                        single(.success(.failure(.expiredToken)))
                    default:
                        single(.success(.failure(.defaultError)))
                    }
                }
            } catch {
                print("get posts request error")
            }
            return Disposables.create()
        }
    }
    
    func deletePost(query: PostIdQuery, productId: String) -> Single<Result<Void, Errors>> {
        return Single.create { single -> Disposable in
            do {
                let request = try PostRouter.deletePost(query: query).asURLRequest()
                AF.request(request, interceptor: AuthInterceptor.interceptor).responseString(emptyResponseCodes: [200]) { response in
                    let statusCode = response.response?.statusCode
                    switch statusCode {
                    case 200:
                        single(.success(.success(())))
                    case 410: // 게시글을 찾을 수 없음
                        single(.success(.failure(.invalidDeletePostRequest)))
                    case 419:
                        single(.success(.failure(.expiredToken)))
                    default :
                        single(.success(.failure(.defaultError)))
                    }
                }
            } catch {
                print("delete post request error")
            }
            return Disposables.create()
        }
    }
}

