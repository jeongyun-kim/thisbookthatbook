//
//  FeedViewController.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/13/24.
//

import UIKit
import iamport_ios
import RxSwift
import RxCocoa

final class FeedViewController: BaseViewController {
    init(vm: FeedViewModel = FeedViewModel(), feedType: RecommendType) {
        super.init(nibName: nil, bundle: nil)
        self.vm = vm
        vm.selectedFeedType.accept(feedType)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let main = FeedView()
    private let disposeBag = DisposeBag()
    private var vm: FeedViewModel!
  
    
    override func loadView() {
        self.view = main
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        vm.reloadCollectionView.accept(())
    }

    override func setupUI() {
        super.setupUI()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "navigation_title_feed".localized
        
    }
    
    override func bind() {
        let vc = WebViewController()
        
        let modifyTrigger = PublishRelay<Post>()
        let deleteTrigger = PublishRelay<Post>()
        let addPostBtnTapped = main.addPostButton.rx.tap
        let likeBtnTappedPost = PublishRelay<Post>()
        let bookmarkBtnTappedPost = PublishRelay<Post>()
        let feedPrefetchIdxs = main.collectionView.rx.prefetchItems
        let payBtnTapped = PublishRelay<Post>()
        let tappedRow = PublishRelay<Int>()
        let paySucceed = PublishRelay<PayQuery>()
        let iamportResponse = PublishRelay<IamportResponse?>()
        let followBtnTapped = BehaviorRelay(value: "")
        let unfollowBtnTapped = BehaviorRelay(value: "")

        let input = FeedViewModel.Input(modifyTrigger: modifyTrigger, deleteTrigger: deleteTrigger,
                                        addPostBtnTapped: addPostBtnTapped, likeBtnTappedPost: likeBtnTappedPost,
                                        bookmarkBtnTappedPost: bookmarkBtnTappedPost, feedPrefetchIdxs: feedPrefetchIdxs,
                                        tappedRow: tappedRow, payBtnTapped: payBtnTapped, paySucceed: paySucceed, iamportResponse: iamportResponse, followBtnTapped: followBtnTapped, unfollowBtnTapped: unfollowBtnTapped)
        let output = vm.transform(input)

        // 포스트 조회 결과
        output.feedResults
            .asDriver(onErrorJustReturn: [])
            .drive(main.collectionView.rx.items(cellIdentifier: FeedCollectionViewCell.identifier, cellType: FeedCollectionViewCell.self)) { (row, element, cell) in
                
                // 셀 구성
                cell.configureCell(element)
                
                // 책 데이터만 가져와서 내부 컬렉션뷰에 보여주기
                Observable.just(element.books)
                    .bind(to: cell.bookCollectionView.rx.items(cellIdentifier: BookCollectionViewCell.identifier, cellType: BookCollectionViewCell.self)) { (row, element, cell) in
                        cell.configureCell(element)
                    }.disposed(by: cell.disposeBag)
                
                // 더보기 버튼 눌렀을 때 -> 포스트 수정 / 포스트 삭제
                cell.userContentsView.moreButton.rx.tap
                    .asSignal()
                    .emit(with: self) { owner, _ in
                        owner.showActionSheet { _ in
                            modifyTrigger.accept(element)
                        } deleteHandler: { _ in
                            deleteTrigger.accept(element)
                        }
                    }.disposed(by: cell.disposeBag)
                
                // 좋아요 버튼 탭 <- 현재 좋아요 한 포스트 보내기
                cell.interactionView.likeButton.rx.tap
                    .asSignal()
                    .map { _ in element }
                    .emit(to: likeBtnTappedPost)
                    .disposed(by: cell.disposeBag)
                
                // 좋아요 버튼 누른 피드 셀 row
                cell.interactionView.likeButton.rx.tap
                    .asSignal()
                    .map { _ in row }
                    .emit(to: tappedRow)
                    .disposed(by: cell.disposeBag)
                
                // 북마크 버튼 탭 <- 현재 북마크 한 포스트 보내기 
                cell.interactionView.bookmarkButton.rx.tap
                    .asSignal()
                    .map { _ in element }
                    .emit(to: bookmarkBtnTappedPost)
                    .disposed(by: cell.disposeBag)
                
                // 북마크 버튼 누른 피드 셀 row
                cell.interactionView.bookmarkButton.rx.tap
                    .asSignal()
                    .map { _ in row }
                    .emit(to: tappedRow)
                    .disposed(by: cell.disposeBag)
            
                // 각 포스트 상세보기로 화면전환
                cell.contentsButton.rx.tap
                    .asSignal()
                    .emit(with: self) { owner, _ in
                        let vc = PostViewController(vm: PostViewModel(), postId: element.post_id)
                        owner.transition(vc)
                    }.disposed(by: cell.disposeBag)
                
                // 책 컬렉션뷰 내 책 선택했을 때, 선택한 책의 상세정보 present
                cell.bookCollectionView.rx.modelSelected(String.self)
                    .bind(with: self) { owner, value in
                        let vc = BookViewController(data: value)
                        vc.sheetPresentationController?.detents = [.medium(), .large()]
                        owner.transition(vc, type: .present)
                    }.disposed(by: cell.disposeBag)
                
                // 결제 버튼 눌렀을 때
                cell.payView.payButton.rx.tap
                    .map { _ in element }
                    .bind(with: self) { owner, value in
                        vc.modalPresentationStyle = .fullScreen
                        owner.transition(vc, type: .present)
                        payBtnTapped.accept(value)
                    }.disposed(by: cell.disposeBag)
                
                cell.userContentsView.followButton.rx.tap
                    .throttle(.seconds(5), scheduler: MainScheduler.instance)
                    .map { _ in element.creator.user_id }
                    .bind(to: followBtnTapped)
                    .disposed(by: cell.disposeBag)
                
                cell.userContentsView.unfollowButton.rx.tap
                    .throttle(.seconds(5), scheduler: MainScheduler.instance)
                    .map { _ in element.creator.user_id }
                    .bind(to: unfollowBtnTapped)
                    .disposed(by: cell.disposeBag)

            }.disposed(by: disposeBag)
        
        // 결제 버튼 눌렀을 때 구성된 payment
        output.payment
            .bind(with: self) { owner, payment in
                Iamport.shared.paymentWebView(
                    webViewMode: vc.wkWebView,
                    userCode: API.Pay.userCode,
                    payment: payment) { response in
                        iamportResponse.accept(response)
                    }
            }.disposed(by: disposeBag)
        
        // 결제에 성공했는지
        output.isSuccessPayment
            .asSignal()
            .emit(with: self) { owner, value in
                if value {
                    vc.showAlertOnlyConfirm(title: "alert_title_payment".localized, message: "alert_msg_payment".localized) { _ in
                        vc.dismiss(animated: true)
                    }
                } else {
                    vc.dismiss(animated: true)
                }
            }.disposed(by: disposeBag)
        
        // 토큰 갱신 에러 외 에러는 토스트메시지로 처리
        output.toastMessage
            .asSignal()
            .emit(with: self) { owner, value in
                owner.showToast(message: value)
            }.disposed(by: disposeBag)
        
        // 만약 토큰 갱신이 불가하다면(= Refresh Token 만료)
        // Alert 띄워서 로그인 화면으로 이동하도록
        output.alert
            .asSignal()
            .emit(with: self) { owner, _ in
                owner.showExpiredTokenAlert()
            }.disposed(by: disposeBag)
        
        // 포스트 작성뷰로 이동
        output.addPostBtnTapped
            .asSignal()
            .emit(with: self) { owner, _ in
                let type = owner.vm.selectedFeedType.value
                let vc = AddPostViewController(vm: AddPostViewModel(), type: type)
                owner.transition(vc)
            }.disposed(by: disposeBag)
    }
}
