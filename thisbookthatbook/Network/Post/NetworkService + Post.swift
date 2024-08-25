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
    func postImages(query: UploadPostQuery, files: [Data?], fileNames: [String], completionHandler: @escaping (Errors?) -> Void){
        do {
            if files.isEmpty {
                postPosts(query: query)
                return
            }
            
            let request = try PostRouter.uploadImage.asURLRequest()
            AF.upload(multipartFormData: { multiPartFormData in
                // index 런타임 에러 방지
                guard files.count == fileNames.count else {
                    completionHandler(.invalidPostRequest)
                    return
                }
                
                for (idx, value) in files.enumerated() {
                    guard let value else { return }
                    multiPartFormData.append(value, withName: "files", fileName: fileNames[idx]+".png", mimeType: "image/png")
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
                case 410:
                    print("toast_create_post_error".localized)
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
    
    func deletePost(postId: String, productId: String) -> Single<Result<Void, Errors>> {
        return Single.create { single -> Disposable in
            do {
                let request = try PostRouter.deletePost(query: postId).asURLRequest()
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
    
    func postLikePost(status: Bool, postId: String) -> Single<Result<LikeStatus, Errors>> {
        return Single.create { [weak self] single -> Disposable in
            do {
                let query = LikeQuery(like_status: status)
                let request = try PostRouter.postLikePost(query: query, id: postId).asURLRequest()
                self?.fetchData(model: LikeStatus.self, request: request) { statusCode, value in
                    guard let statusCode else { return }
                    switch statusCode {
                    case 200:
                        guard let value else { return }
                        single(.success(.success(value)))
                    case 400:
                        single(.success(.failure(.invalidLikePostRequest)))
                    case 410:
                        single(.success(.failure(.invalidPost)))
                    case 419:
                        single(.success(.failure(.expiredToken)))
                    default:
                        single(.success(.failure(.defaultError)))
                    }
                }
            } catch {
                print("like request error")
            }
            return Disposables.create()
        }
    }
    
    func postBookmarkPost(status: Bool, postId: String) -> Single<Result<BookmarkStatus, Errors>> {
        return Single.create { [weak self] single -> Disposable in
            do {
                let query = BookmarkQuery(like_status: status)
                let request = try PostRouter.postBookmarkPost(query: query, id: postId).asURLRequest()
                self?.fetchData(model: BookmarkStatus.self, request: request) { statusCode, value in
                    guard let statusCode else { return }
                    switch statusCode {
                    case 200:
                        guard let value else { return }
                        single(.success(.success(value)))
                    case 400:
                        single(.success(.failure(.invalidLikePostRequest)))
                    case 410:
                        single(.success(.failure(.invalidPost)))
                    case 419:
                        single(.success(.failure(.expiredToken)))
                    default:
                        single(.success(.failure(.defaultError)))
                    }
                }
            } catch {
                print("like request error")
            }
            return Disposables.create()
        }
    }
    
    func getPostData(_ postId: String) -> Single<Result<Post, Errors>> {
        return Single.create { [weak self] single -> Disposable in
            do {
                let request = try PostRouter.getPostData(id: postId).asURLRequest()
                self?.fetchData(model: Post.self, request: request) { statusCode, value in
                    guard let statusCode else { return }
                    print(statusCode)
                    switch statusCode {
                    case 200:
                        guard let value else { return }
                        single(.success(.success(value)))
                    case 400:
                        single(.success(.failure(.invalidPostRequest)))
                    case 419:
                        single(.success(.failure(.expiredToken)))
                    default:
                        single(.success(.failure(.defaultError)))
                    }
                }
            } catch {
                print("get post data request error")
            }
            return Disposables.create()
        }
    }
    
    func postComment(_ id: String, query: CommentQuery) -> Single<Result<Comment, Errors>> {
        return Single.create { single -> Disposable in
            do {
                let request = try PostRouter.postComment(query: query, id: id).asURLRequest()
                self.fetchData(model: Comment.self, request: request) { statusCode, value in
                    guard let statusCode else { return }
                    switch statusCode {
                    case 200:
                        guard let value else { return }
                        single(.success(.success(value)))
                    case 400:
                        single(.success(.failure(.emptyContent)))
                    case 410:
                        single(.success(.failure(.invalidPost)))
                    case 419:
                        single(.success(.failure(.expiredToken)))
                    default:
                        single(.success(.failure(.defaultError)))
                    }
                }
            } catch {
                print("post comment request error")
            }
            return Disposables.create()
        }
    }
    
    func deleteComment(postId: String, commentId: String) -> Single<Result<Void, Errors>> {
        return Single.create { single -> Disposable in
            do {
                let request = try PostRouter.deleteComment(postId: postId, commentId: commentId).asURLRequest()
                AF.request(request, interceptor: AuthInterceptor.interceptor).responseString(emptyResponseCodes: [200]) { response in
                    let statusCode = response.response?.statusCode
                    switch statusCode {
                    case 200:
                        single(.success(.success(())))
                    case 410: // 게시글을 찾을 수 없음
                        single(.success(.failure(.invalidDeleteCommentRequest)))
                    case 419:
                        single(.success(.failure(.expiredToken)))
                    default :
                        single(.success(.failure(.defaultError)))
                    }
                }
            } catch {
                print("delete comment request error!")
            }
            return Disposables.create()
        }
        
    }
}

