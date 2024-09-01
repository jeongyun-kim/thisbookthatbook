//
//  FeedViewModel.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/18/24.
//

import Foundation
import RxSwift
import RxCocoa
import iamport_ios

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
        let payBtnTapped: PublishRelay<Post>
        let paySucceed: PublishRelay<PayQuery>
        let iamportResponse: PublishRelay<IamportResponse?>
        let followBtnTapped: BehaviorRelay<String>
        let unfollowBtnTapped: BehaviorRelay<String>
    }
    
    struct Output {
        let toastMessage: PublishRelay<String>
        let alert: PublishRelay<Void>
        let feedResults: BehaviorRelay<[Post]>
        let addPostBtnTapped: ControlEvent<Void>
        let payment: PublishRelay<IamportPayment>
        let isSuccessPayment: PublishRelay<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        // Output
        let toastMessage = PublishRelay<String>()
        let alert = PublishRelay<Void>()
        let feedResults: BehaviorRelay<[Post]> = BehaviorRelay(value: [])
        let payment = PublishRelay<IamportPayment>()
        let isValidPayment = PublishRelay<Bool>()
        let validateReceipt = PublishRelay<PayQuery>()
        
        // 마지막 커서는 0
        var nextCursor = ""
        // 업데이트 할 Cell Row
        let cellRow = BehaviorRelay(value: 0)
        // 결제할 포스트 정보
        let paiedPost = BehaviorRelay<Post?>(value: nil)
        
        // MARK: Reload
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
        
        // MARK: 페이지네이션
        input.feedPrefetchIdxs
            .compactMap { $0.first }
            .filter { $0.row == feedResults.value.count - 4 && nextCursor != "0" }
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
                    default:
                        toastMessage.accept(error.rawValue.localized)
                    }
                }
            }.disposed(by: disposeBag)
        
        // MARK: 게시글 수정 / 삭제
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
                    default:
                        toastMessage.accept(error.rawValue.localized)
                    }
                }
            }.disposed(by: disposeBag)
        
        // MARK: 좋아요 / 북마크
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
        
        // 현재 좋아요나 북마크 한 셀 Row값
        input.tappedRow
            .bind(to: cellRow)
            .disposed(by: disposeBag)
        
        // MARK: 결제
        // 결제 버튼 눌렀을 때, payment 구성
        input.payBtnTapped
            .subscribe(with: self) { owner, value in
                let key = API.key
                guard let price = value.price else { return }
                
                let data = IamportPayment(pg: PG.html5_inicis.makePgRawName(pgId: API.Pay.pgID),
                                             merchant_uid: "ios_\(key)_\(Int(Date().timeIntervalSince1970))", amount: "\(price)").then { payment in
                    payment.pay_method = PayMethod.card.rawValue
                    payment.name = "이책저책 포스트"
                    payment.buyer_name = "김정윤"
                    payment.app_scheme = "tbtb.sesac"
                }
               
                payment.accept(data)
            }.disposed(by: disposeBag)
    
        // 결제할 포스트의 정보 업데이트
        input.payBtnTapped
            .bind(to: paiedPost)
            .disposed(by: disposeBag)
        
        // 결제 응답 -> 응답값에 따라 영수증 검증 또는 결제창 내리기
        input.iamportResponse
            .subscribe(with: self) { owner, response in
                guard let response, let isSuccess = response.success else { return }
                if isSuccess {
                    guard let uid = response.imp_uid else { return }
                    guard let post = paiedPost.value else { return }
                    let query = PayQuery(imp_uid: uid, post_id: post.post_id)
                    validateReceipt.accept(query)
                } else {
                    isValidPayment.accept(false)
                }
            }.disposed(by: disposeBag)
        
        // 영수증 검증 -> 성공 시 Alert / 실패 시 토스트메시지 또는 Alert
        validateReceipt
            .flatMap { NetworkService.shared.postValidateReciept(query: $0) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(_):
                    // 영수증 검증 성공!
                    isValidPayment.accept(true)
                case .failure(let error):
                    // 영수증 검증 실패
                    switch error {
                    case .expiredToken:
                        alert.accept(())
                    default:
                        toastMessage.accept(error.rawValue.localized)
                    }
                }
            }.disposed(by: disposeBag)
        
        // MARK: 팔로우 / 언팔로우
        // 팔로우 버튼 눌렀을 때
        input.followBtnTapped
            .filter { !$0.isEmpty }
            .flatMap { NetworkService.shared.postFollowUser($0) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(_):
                    owner.updateFollowings(input.followBtnTapped.value)
                    feedResults.accept(feedResults.value)
                case .failure(let error):
                    switch error {
                    case .expiredToken:
                        alert.accept(())
                    default:
                        toastMessage.accept(error.rawValue.localized)
                    }
                }
            }.disposed(by: disposeBag)
        
        // 언팔로우 했을 때
        input.unfollowBtnTapped
            .filter { !$0.isEmpty }
            .flatMap { NetworkService.shared.delUnfollowUser($0) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(_):
                    owner.updateFollowings(input.unfollowBtnTapped.value)
                    feedResults.accept(feedResults.value)
                case .failure(let error):
                    switch error {
                    case .expiredToken:
                        alert.accept(())
                    default:
                        toastMessage.accept(error.rawValue.localized)
                    }
                }
            }.disposed(by: disposeBag)

        let output = Output(toastMessage: toastMessage, alert: alert, 
                            feedResults: feedResults, addPostBtnTapped: input.addPostBtnTapped,
                            payment: payment, isSuccessPayment: isValidPayment)
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
