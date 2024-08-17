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
    func refreshAndPostImages(query: Post, files: [ImageFile], completionHandler: @escaping (Errors?) -> Void){
        getRefreshToken { error in
            if let error {
                completionHandler(error)
            } else {
                self.postImages(query: query, files: files) { error in
                    completionHandler(error)
                }
            }
        }
    }
    
    func refreshAndPost(query: Post) {
        getRefreshToken { [weak self] error in
            if let error {
                print(error)
            } else {
                self?.postPosts(query: query)
            }
        }
    }
    
    func postImages(query: Post, files: [ImageFile], completionHandler: @escaping (Errors?) -> Void){
        
        do {
            let request = try PostRouter.uploadImage.asURLRequest()
            AF.upload(multipartFormData: { multiPartFormData in
                for file in files {
                    guard let image = file.image else { continue }
                    multiPartFormData.append(image, withName: "files", fileName: file.imageName+".png", mimeType: "image/png")
                }
            }, with: request).responseDecodable(of: Files.self) { response in
                let statusCode = response.response?.statusCode
                if statusCode == 419 {
                    self.refreshAndPostImages(query: query, files: files) { error in
                        if let error {
                            completionHandler(error)
                        }
                    }
                    return
                } else {
                    switch response.result {
                    case .success(let value):
                        switch statusCode {
                        case 200:
                            var query = query
                            query.files = value.files
                            self.postPosts(query: query)
                        default:
                            completionHandler(Errors.defaultError)
                        }
                    case .failure(let error):
                        completionHandler(Errors.defaultError)
                    }
                }
            }
        } catch {
            print("post image request error")
        }
    }
    
    func postPosts(query: Post) {
        do {
            let request = try PostRouter.uploadPost(query: query).asURLRequest()
            fetchData(model: PostResults.self, request: request) { statusCode, value in
                guard let statusCode else { return }
                switch statusCode {
                case 200:
                    guard let value else { return }
                    print(#function, value)
                case 419:
                    self.refreshAndPost(query: query)
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
    
  
}

