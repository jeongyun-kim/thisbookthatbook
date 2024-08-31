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
    let deleteComment = PublishRelay<Comment>()
    let deletePost = PublishRelay<Void>()
    let followBtnTapped = PublishRelay<Void>()
    let unfollowBtnTapped = PublishRelay<Void>()

    // Output
    let postData: BehaviorRelay<Post?> = BehaviorRelay(value: nil)
    let commentsData = BehaviorRelay<[Comment]>(value: [])
    let isExpiredTokenError = PublishRelay<Bool>()
    let toastMessage = PublishRelay<String>()
    let deletePostSucceed = PublishRelay<Void>()
   
    init() {
        let commentData = BehaviorRelay(value: "")
        let postIdData = BehaviorRelay(value: "")
        
        // 화면전환하면서 들어온 포스트 아이디
        postId
            .bind(to: postIdData)
            .disposed(by: disposeBag)
       
        // 포스트 아이디로 포스트 상세정보 불러오기
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
        
        // 현재 사용자가 입력한 댓글
        comment
            .bind(to: commentData)
            .disposed(by: disposeBag)
        
        // 사용자가 댓글을 생성하려고 리턴키 눌렀을 때
        returnKeyTapped
            .map { CommentQuery(content: commentData.value) }
            .flatMap { NetworkService.shared.postComment(postIdData.value, query: $0) }
            .bind(with: self) { owner, result in
                switch result {
                case .success(_):
                    owner.postId.accept(postIdData.value)
                case .failure(let error):
                    owner.isExpiredTokenError.accept(error == .expiredToken)
                }
            }.disposed(by: disposeBag)
        
        // 사용자가 댓글을 삭제할 때
        deleteComment
            .map { (postIdData.value, $0.comment_id) }
            .flatMap { NetworkService.shared.deleteComment(postId: $0.0, commentId: $0.1) }
            .bind(with: self) { owner, result in
                switch result {
                case .success(_):
                    owner.postId.accept(postIdData.value)
                case .failure(let error):
                    switch error {
                    case .expiredToken:
                        owner.isExpiredTokenError.accept(true)
                    default:
                        owner.toastMessage.accept(error.rawValue.localized)
                    }
                }
            }.disposed(by: disposeBag)
        
        // 포스트 삭제
        deletePost
            .withLatestFrom(postData)
            .compactMap { $0 }
            .flatMap { NetworkService.shared.deletePost(postId: $0.post_id, productId: $0.product_id) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(_):
                    owner.deletePostSucceed.accept(())
                case .failure(let error):
                    switch error {
                    case .expiredToken:
                        owner.isExpiredTokenError.accept(true)
                    default:
                        owner.toastMessage.accept(error.rawValue.localized)
                    }
                }
            }.disposed(by: disposeBag)
        
        // 팔로우
        followBtnTapped
            .withLatestFrom(postData)
            .compactMap { $0 }
            .map { $0.creator.user_id }
            .flatMap { NetworkService.shared.postFollowUser($0) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(_):
                    guard let id = owner.postData.value?.creator.user_id else { return }
                    owner.updateFollowings(id)
                    owner.postData.accept(owner.postData.value)
                 
                case .failure(let error):
                    switch error {
                    case .expiredToken:
                        owner.isExpiredTokenError.accept(true)
                    default:
                        owner.toastMessage.accept(error.rawValue.localized)
                    }
                }
            }.disposed(by: disposeBag)
        
        // 언팔로우
        unfollowBtnTapped
            .withLatestFrom(postData)
            .compactMap { $0 }
            .map { $0.creator.user_id }
            .flatMap { NetworkService.shared.delUnfollowUser($0) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(_):
                    guard let id = owner.postData.value?.creator.user_id else { return }
                    owner.updateFollowings(id)
                    owner.postData.accept(owner.postData.value)
                case .failure(let error):
                    switch error {
                    case .expiredToken:
                        owner.isExpiredTokenError.accept(true)
                    default:
                        owner.toastMessage.accept(error.rawValue.localized)
                    }
                }
            }.disposed(by: disposeBag)
    }
    
    private func updateFollowings(_ userId: String) {
        var list = UserDefaultsManager.shared.followings
        if list.contains(userId) {
            guard let idx = list.firstIndex(of: userId) else { return }
            list.remove(at: idx)
        } else {
            list.append(userId)
        }
        UserDefaultsManager.shared.followings = list
    }
}
