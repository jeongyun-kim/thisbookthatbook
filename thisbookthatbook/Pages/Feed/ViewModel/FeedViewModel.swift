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
    
    let selectedFeedType = BehaviorRelay<RecommendType>(value: .give_recommend)
    let reloadCollectionView = PublishRelay<Void>()
    
    struct Input {
        let modifyTrigger: PublishRelay<Post>
        let deleteTrigger: PublishRelay<Post>
        let addPostBtnTapped: ControlEvent<Void>
        let likeBtnTappedPost: PublishRelay<Post>
        let bookmarkBtnTappedPost: PublishRelay<Post>
        let feedPrefetchIdxs: ControlEvent<[IndexPath]>
        let tappedRow: PublishRelay<Int>
    }
    
    struct Output {
        let toastMessage: PublishRelay<String>
        let alert: PublishRelay<Void>
        let feedResults: BehaviorRelay<[Post]>
        let addPostBtnTapped: ControlEvent<Void>
    }
    
    func transform(_ input: Input) -> Output {
        let toastMessage = PublishRelay<String>()
        let alert = PublishRelay<Void>()
        let feedResults: BehaviorRelay<[Post]> = BehaviorRelay(value: [])
        
        // 마지막 커서는 0
        var nextCursor = ""
        // 업데이트 할 Cell Row
        let cellRow = BehaviorRelay(value: 0)
        
        // 뷰를 새로 불러올 때마다 실시간 반영된 데이터 불러오기
        reloadCollectionView
            .withLatestFrom(selectedFeedType)
            .map {
                let query = GetPostsQuery(next: "", product_id: $0.rawValue)
                return query
            }
            .flatMap { NetworkService.shared.getPosts(query: $0) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    nextCursor = value.next_cursor // 다음 커서 반영
                    let posts = value.data
                    feedResults.accept(posts)
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
        
        // 페이지네이션
        input.feedPrefetchIdxs
            .compactMap { $0.first }
            .filter { $0.row == feedResults.value.count - 5 && nextCursor != "0" }
            .withLatestFrom(selectedFeedType)
            .map { GetPostsQuery(next: nextCursor, product_id: $0.rawValue) }
            .flatMap { NetworkService.shared.getPosts(query: $0) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    nextCursor = value.next_cursor // 다음 커서 반영
                    
                    let posts = value.data
                    var currentList = feedResults.value
                    currentList.append(contentsOf: posts)
                    feedResults.accept(currentList)
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
            .flatMap { NetworkService.shared.deletePost(postId: $0.post_id, productId: $0.product_id) }
            .bind(with: self) { owner, result in
                switch result {
                case .success(_):
                    // 삭제 성공했다면 서버에서 피드 데이터 다시 받아오게 현재 선택되어있던 피드 타입 전달
                    owner.reloadCollectionView.accept(())
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
                    owner.updateLikes(feedResults, row: cellRow.value)
                case .failure(let error):
                    switch error {
                    case .expiredToken: // 토큰 만료 시 alert 띄우라고 신호주기
                        alert.accept(())
                    default: // 그 외는 토스트메시지로 처리
                        toastMessage.accept(error.rawValue.localized)
                    }
                }
            }.disposed(by: disposeBag)
        
        // 북마크 버튼 탭했을 때
        input.bookmarkBtnTappedPost
            .flatMap { NetworkService.shared.postBookmarkPost(status: !$0.isBookmarkPost, postId: $0.post_id) }
            .bind(with: self) { owner, result in
                switch result {
                case .success(_):
                    owner.updateLikes2(feedResults, row: cellRow.value)
                case .failure(let error):
                    switch error {
                    case .expiredToken: // 토큰 만료 시 alert 띄우라고 신호주기
                        alert.accept(())
                    default: // 그 외는 토스트메시지로 처리
                        toastMessage.accept(error.rawValue.localized)
                    }
                }
            }.disposed(by: disposeBag)
        
        input.tappedRow
            .bind(to: cellRow)
            .disposed(by: disposeBag)
            
        
        let output = Output(toastMessage: toastMessage, alert: alert, 
                            feedResults: feedResults, addPostBtnTapped: input.addPostBtnTapped)
        return output
    }
    
    // 좋아요 업데이트
    private func updateLikes(_ posts: BehaviorRelay<[Post]>, row: Int) {
        var currentList = posts.value
        let id = UserDefaultsManager.shared.id
        if currentList[row].likes.contains(id) {
            guard let idx = currentList[row].likes.firstIndex(of: id) else { return }
            currentList[row].likes.remove(at: idx)
        } else {
            currentList[row].likes.append(id)
        }
        posts.accept(currentList)
    }
    
    // 북마크 업데이트
    private func updateLikes2(_ posts: BehaviorRelay<[Post]>, row: Int) {
        var currentList = posts.value
        let id = UserDefaultsManager.shared.id
        if currentList[row].likes2.contains(id) {
            guard let idx = currentList[row].likes2.firstIndex(of: id) else { return }
            currentList[row].likes2.remove(at: idx)
        } else {
            currentList[row].likes2.append(id)
        }
        posts.accept(currentList)
    }
}
