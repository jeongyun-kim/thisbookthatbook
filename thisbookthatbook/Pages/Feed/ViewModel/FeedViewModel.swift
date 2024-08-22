//
//  FeedViewModel.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/18/24.
//

import Foundation
import RxSwift
import RxCocoa

final class FeedViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let selectedSegmentIdx: ControlProperty<Int>
        let modifyTrigger: PublishRelay<Post>
        let deleteTrigger: PublishRelay<Post>
        let addPostBtnTapped: ControlEvent<Void>
        let likeBtnTappedPost: PublishRelay<Post>
    }
    
    struct Output {
        let toastMessage: PublishRelay<String>
        let alert: PublishRelay<Void>
        let feedResults: BehaviorRelay<[Post]>
        let addPostBtnTapped: ControlEvent<Void>
        let selectedSegmentIdx: BehaviorRelay<Int>
    }
    
    func transform(_ input: Input) -> Output {
        let id = UserDefaultsManager.shared.id
        let likedPostIndex = BehaviorRelay(value: 0)
        
        let toastMessage = PublishRelay<String>()
        let alert = PublishRelay<Void>()
        let feedResults: BehaviorRelay<[Post]> = BehaviorRelay(value: [])
        let selectedSegmentIdx = BehaviorRelay(value: 0)
        
        // 새로운 피드 카테고리 선택 인덱스 정보
        input.selectedSegmentIdx
            .asDriver()
            .drive(selectedSegmentIdx)
            .disposed(by: disposeBag)
        
        // 새로운 카테고리 선택될 때마다 서버 통신 -> 결과 받아오기
        selectedSegmentIdx
            .map {
                let id = RecommendType.allCases[$0].rawValue
                let query = GetPostsQuery(next: "0", product_id: id)
                return query
            }
            .flatMap { NetworkService.shared.getPosts(query: $0) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    feedResults.accept(value)
                case .failure(let error):
                    switch error {
                    case .expiredToken:
                        // 토큰 갱신이 불가하다면 재로그인 필요
                        alert.accept(())
                        // 재로그인할거니까 저장해뒀던 사용자 정보 모두 지우기 -> 앱을 껐다키면 로그인 화면으로 이동 
                        UserDefaultsManager.shared.deleteAllData()
                    default:
                        toastMessage.accept("toast_default_error".localized)
                    }
                }
            }.disposed(by: disposeBag)
        
        // 게시글 수정
        input.modifyTrigger
            .bind(with: self) { owner, value in
                print("여기서 게시글 수정으로 이동 \(value)")
            }.disposed(by: disposeBag)
        
        // 게시글 삭제
        input.deleteTrigger
            .flatMap { NetworkService.shared.deletePost(query: PostIdQuery(id: $0.post_id), productId: $0.product_id)}
            .bind(with: self) { owner, result in
                switch result {
                case .success(_):
                    // 삭제 성공했다면 서버에서 피드 데이터 다시 받아오게 현재 선택되어있던 인덱스값 전달
                    let idx = selectedSegmentIdx.value
                    selectedSegmentIdx.accept(idx)
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
                case .success(let value): // 좋아요 반영했을 때 서버 데이터 다시 받아오기
                    selectedSegmentIdx.accept(selectedSegmentIdx.value)
                case .failure(let error):
                    switch error {
                    case .expiredToken: // 토큰 만료 시 alert 띄우라고 신호주기
                        alert.accept(())
                    default: // 그 외는 토스트메시지로 처리
                        toastMessage.accept(error.rawValue.localized)
                    }
                }
            }.disposed(by: disposeBag)
        
        let output = Output(toastMessage: toastMessage, alert: alert, 
                            feedResults: feedResults, addPostBtnTapped: input.addPostBtnTapped,
                            selectedSegmentIdx: selectedSegmentIdx)
        return output
    }
}
