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
    
    let postId = PublishRelay<String>()

    let postData: BehaviorRelay<Post?> = BehaviorRelay(value: nil)
    let comments = BehaviorRelay<[Comment]>(value: [])
    let isExpiredTokenError = PublishRelay<Bool>()
   
    init() {
        postId
            .flatMap { NetworkService.shared.getPostData($0) }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let value):
                    owner.postData.accept(value)
                    let comments = value.comments
                    owner.comments.accept(comments)
                case .failure(let error):
                    owner.isExpiredTokenError.accept(error == .expiredToken)
                }
            }.disposed(by: disposeBag)
    }
    
    func transform() {
       
    }
}
