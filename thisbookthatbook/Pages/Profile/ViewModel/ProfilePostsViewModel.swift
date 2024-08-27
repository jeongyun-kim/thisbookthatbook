//
//  ProfilePostsViewModel.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/26/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfilePostsViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    
    private let start = ""
    
    let viewWillAppear = PublishRelay<Int>()
    let currentView = BehaviorRelay(value: 0)
    
    struct Input {
        let modifyTrigger: PublishRelay<Post>
        let deleteTrigger: PublishRelay<Post>
        let bookmarkBtnTappedPost: PublishRelay<Post>
        let likeBtnTappedPost: PublishRelay<Post>
    }
    
    struct Output {
        let posts: BehaviorRelay<[Post]>
        let alert: PublishRelay<Void>
        let toastMessage: PublishRelay<String>
    }
    
    func transform(_ input: Input) -> Output {
        
        let toastMessage = PublishRelay<String>()
        let alert = PublishRelay<Void>()
        let recommendPosts = BehaviorRelay<[Post]>(value: [])
        let recommendedPosts = BehaviorRelay<[Post]>(value: [])
        let allUserPosts = BehaviorRelay<[Post]>(value: [])

        Observable
            .combineLatest(recommendPosts, recommendedPosts)
            .bind(with: self) { owner, value in
                let data = value.0 + value.1
                let result = data.sorted { $0.createdAt > $1.createdAt }
                allUserPosts.accept(result)
            }.disposed(by: disposeBag)
      
        // viewWillAppear 시마다 호출
        // - '추천해요'  포스트
        viewWillAppear
            .bind(with: self) { owner, _ in
                owner.getPosts(next: owner.start, productId: .give_recommend, toast: toastMessage, alert: alert) { value in
                    recommendPosts.accept(value)
                }
            }.disposed(by: disposeBag)
        
        // - '추천해주세요' 포스트
        viewWillAppear
            .bind(with: self) { owner, _ in
                owner.getPosts(next: owner.start, productId: .recieve_recommended, toast: toastMessage, alert: alert) { value in
                    recommendedPosts.accept(value)
                }
            }.disposed(by: disposeBag)

        // 포스트 수정
        input.modifyTrigger
            .bind(with: self) { owner, value in
                print("여기서 게시글 수정으로 이동 \(value)")
            }.disposed(by: disposeBag)
        
        // 포스트 삭제
        input.deleteTrigger
            .flatMap { NetworkService.shared.deletePost(postId: $0.post_id, productId: $0.product_id) }
            .bind(with: self) { owner, result in
                switch result {
                case .success(_):
                    owner.viewWillAppear.accept(owner.currentView.value)
                case .failure(let error):
                    switch error {
                    case .expiredToken:
                        // 토큰 갱신이 불가하다면 재로그인 필요
                        alert.accept(())
                        // 재로그인할거니까 저장해뒀던 사용자 정보 모두 지우기 -> 앱을 껐다키면 로그인 화면으로 이동
                        UserDefaultsManager.shared.deleteAllData()
                    default:
                        let errorMessage = error.rawValue.localized
                        toastMessage.accept(errorMessage)
                    }
                }
            }.disposed(by: disposeBag)
        
        // 좋아요 버튼 탭했을 때
        input.likeBtnTappedPost
            .flatMap { NetworkService.shared.postLikePost(status: !$0.isLikePost, postId: $0.post_id) }
            .bind(with: self) { owner, result in
                switch result {
                case .success(_): // 좋아요 반영했을 때 서버 데이터 다시 받아오기
                    owner.viewWillAppear.accept(owner.currentView.value)
                case .failure(let error):
                    switch error {
                    case .expiredToken: // 토큰 만료 시 alert 띄우라고 신호주기
                        alert.accept(())
                    default: // 그 외는 토스트메시지로 처리
                        toastMessage.accept(error.rawValue.localized)
                    }
                }
            }.disposed(by: disposeBag)
        
        // 북마크 버튼 눌렀을 때
        input.bookmarkBtnTappedPost
            .flatMap { NetworkService.shared.postBookmarkPost(status: !$0.isBookmarkPost, postId: $0.post_id) }
            .bind(with: self) { owner, result in
                switch result {
                case .success(_):
                    owner.viewWillAppear.accept(owner.currentView.value)
                case .failure(let error):
                    switch error {
                    case .expiredToken: // 토큰 만료 시 alert 띄우라고 신호주기
                        alert.accept(())
                    default: // 그 외는 토스트메시지로 처리
                        toastMessage.accept(error.rawValue.localized)
                    }
                }
            }.disposed(by: disposeBag)
            
            
        let output = Output(posts: allUserPosts, alert: alert, toastMessage: toastMessage)
        return output
    }
    
    private func getPosts(next: String, productId: RecommendType, toast: PublishRelay<String>, alert: PublishRelay<Void>, completionHandler: @escaping (([Post]) -> Void)) {
        let query = GetPostsQuery(next: next, product_id: productId.rawValue)
        
        Observable.just(query)
            .flatMap { NetworkService.shared.getPosts(query: $0) }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let value):
                    let result = owner.getFilteredPosts(value.data)
                    completionHandler(result)
                case .failure(let error):
                    switch error {
                    case .expiredToken:
                        alert.accept(())
                    default:
                        toast.accept(error.rawValue.localized)
                    }
                }
            }.disposed(by: disposeBag)
        
    }
    
    private func getFilteredPosts(_ data: [Post]) -> [Post] {
        let id = UserDefaultsManager.shared.id
        let contentsType = UserContentsType.allCases[currentView.value]
        
        switch contentsType {
        case .post:
            return data.filter { $0.creator.user_id == id }
        case .like:
            return data.filter { $0.isLikePost }
        case .bookmark:
            return data.filter { $0.isBookmarkPost }
        }
    }
}
