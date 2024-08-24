//
//  PostViewModel.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/23/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PostViewModel {
    private let disposeBag = DisposeBag()
    
    // Input
    let postId = PublishRelay<String>()
    let returnKeyTapped = PublishRelay<Void>()
    let comment = BehaviorRelay(value: "")

    // Output
    let postData: BehaviorRelay<Post?> = BehaviorRelay(value: nil)
    let commentsData = BehaviorRelay<[Comment]>(value: [])
    let isExpiredTokenError = PublishRelay<Bool>()
    let toastMessage = PublishRelay<String>()
   
    init() {
        let commentData = BehaviorRelay(value: "")
        let postIdData = BehaviorRelay(value: "")
        
        postId
            .bind(to: postIdData)
            .disposed(by: disposeBag)
       
        postId
            .flatMap { NetworkService.shared.getPostData($0) }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let value):
                    owner.postData.accept(value)
                    let comments = value.comments
                    owner.commentsData.accept(comments)
                case .failure(let error):
                    switch error {
                    case .expiredToken:
                        owner.isExpiredTokenError.accept(true)
                    default:
                        owner.toastMessage.accept(error.rawValue.localized)
                    }
                }
            }.disposed(by: disposeBag)
        
        comment
            .bind(to: commentData)
            .disposed(by: disposeBag)
        
        returnKeyTapped
            .map { CommentQuery(content: commentData.value) }
            .flatMap { NetworkService.shared.postComment(postIdData.value, query: $0) }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let value):
                    owner.postId.accept(postIdData.value)
                case .failure(let error):
                    owner.isExpiredTokenError.accept(error == .expiredToken)
                }
            }.disposed(by: disposeBag)
    }
}
