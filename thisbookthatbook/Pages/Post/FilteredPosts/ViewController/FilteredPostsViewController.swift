//
//  ProfilePostsViewController.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/26/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

// - 사용자가 쓴 모든 글
// - 사용자가 좋아요 한 글
// - 사용자가 북마크 한 글
// - 사용자가 팔로잉 한 사용자들의 글
final class FilteredPostsViewController: BaseViewController {
    init(vm: FilteredPostsViewModel, dataType: PostFilterType) {
        super.init(nibName: nil, bundle: nil)
        self.vm = vm
        vm.postFilterType.accept(dataType)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let disposeBag = DisposeBag()
    private var vm: FilteredPostsViewModel!
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .FeedCollectionViewLayout())
        collectionView.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.identifier)
        collectionView.backgroundColor = Resource.Colors.gray6
        return collectionView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        vm.viewWillAppear.accept(vm.postFilterType.value)
    }
    
    override func setupHierarchy() {
        view.addSubview(collectionView)
    }
    
    override func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Resource.Tabman.height)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
    
    override func bind() {
        let likeBtnTappedPost = PublishRelay<Post>()
        let modifyTrigger = PublishRelay<Post>()
        let deleteTrigger = PublishRelay<Post>()
        let bookmarkBtnTappedPost = PublishRelay<Post>()
        let prefetchIdxs = collectionView.rx.prefetchItems
        let tappedRow = PublishRelay<Int>()
        let followBtnTapped = BehaviorRelay(value: "")
        let unfollowBtnTapped = BehaviorRelay(value: "")
        
        let input = FilteredPostsViewModel.Input(modifyTrigger: modifyTrigger, deleteTrigger: deleteTrigger, 
                                                bookmarkBtnTappedPost: bookmarkBtnTappedPost, likeBtnTappedPost: likeBtnTappedPost,
                                                prefetchIdxs: prefetchIdxs, tappedRow: tappedRow, 
                                                 followBtnTapped: followBtnTapped, unfollowBtnTapped: unfollowBtnTapped)
        let output = vm.transform(input)
   
        // 현재 선택한 탭에 따른 포스트들
        output.posts
            .asDriver()
            .drive(collectionView.rx.items(cellIdentifier: FeedCollectionViewCell.identifier, cellType: FeedCollectionViewCell.self)) { (row, element, cell) in
                
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
                
                // 현재 좋아요 한 포스트의 인덱스
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
                
                // 현재 북마크 한 포스트의 인덱스
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
                
                // 팔로우했을 때
                cell.userContentsView.followButton.rx.tap
                    .throttle(.seconds(5), scheduler: MainScheduler.instance)
                    .map { _ in element.creator.user_id }
                    .bind(to: followBtnTapped)
                    .disposed(by: cell.disposeBag)
                
                // 언팔로우했을 때
                cell.userContentsView.unfollowButton.rx.tap
                    .throttle(.seconds(5), scheduler: MainScheduler.instance)
                    .map { _ in element.creator.user_id }
                    .bind(to: unfollowBtnTapped)
                    .disposed(by: cell.disposeBag)
                
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
    }
    
}
