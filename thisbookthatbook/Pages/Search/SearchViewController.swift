//
//  SearchViewController.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 9/1/24.
//

import UIKit
import iamport_ios
import RxSwift
import RxCocoa

final class SearchViewController: BaseViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
        bindData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let disposeBag = DisposeBag()

    private let vm = SearchViewModel()
    
    private let searchBar = CustomSearchBar("placeholder_search_hashtags".localized)
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .FeedCollectionViewLayout())
        collectionView.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.identifier)
        collectionView.backgroundColor = Resource.Colors.gray6
        collectionView.keyboardDismissMode = .onDrag
         return collectionView
     }()

    override func setupHierarchy() {
        view.addSubview(searchBar)
        view.addSubview(collectionView)
    }
    
    override func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    override func setupUI() {
        super.setupUI()
        navigationItem.title = "navigitaion_title_search".localized
    }
    
    private func bindData() {
        let vc = WebViewController()

        let viewWillAppear = rx.viewWillAppear
        let searchBtnTapped = searchBar.rx.searchButtonClicked
        let searchkeyword = searchBar.rx.text.orEmpty
        let modifyTrigger = PublishRelay<Post>()
        let deleteTrigger = PublishRelay<Post>()
        let likeBtnTappedPost = PublishRelay<Post>()
        let bookmarkBtnTappedPost = PublishRelay<Post>()
        let prefetchIdxs = collectionView.rx.prefetchItems
        let payBtnTapped = PublishRelay<Post>()
        let tappedRow = PublishRelay<Int>()
        let paySucceed = PublishRelay<PayQuery>()
        let iamportResponse = PublishRelay<IamportResponse?>()
        let followBtnTapped = BehaviorRelay(value: "")
        let unfollowBtnTapped = BehaviorRelay(value: "")
        
        let input = SearchViewModel.Input(viewWillAppear: viewWillAppear, searchBtnTapped: searchBtnTapped, searchKeyword: searchkeyword, modifyTrigger: modifyTrigger, deleteTrigger: deleteTrigger, likeBtnTappedPost: likeBtnTappedPost,
                                          bookmarkBtnTappedPost: bookmarkBtnTappedPost, prefetchIdxs: prefetchIdxs, tappedRow: tappedRow, payBtnTapped: payBtnTapped,
                                          paySucceed: paySucceed, iamportResponse: iamportResponse,
                                          followBtnTapped: followBtnTapped, unfollowBtnTapped: unfollowBtnTapped)
        let output = vm.transform(input)
        
        output.posts
            .asDriver(onErrorJustReturn: [])
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
                
                // 팔로우 했을 때
                cell.userContentsView.followButton.rx.tap
                    .throttle(.seconds(5), scheduler: MainScheduler.instance)
                    .map { _ in element.creator.user_id }
                    .bind(to: followBtnTapped)
                    .disposed(by: cell.disposeBag)
                
                // 언팔로우 했을 때
                cell.userContentsView.unfollowButton.rx.tap
                    .throttle(.seconds(5), scheduler: MainScheduler.instance)
                    .map { _ in element.creator.user_id }
                    .bind(to: unfollowBtnTapped)
                    .disposed(by: cell.disposeBag)

            }.disposed(by: disposeBag)
        
        output.alert
            .asSignal()
            .emit(with: self) { owner, _ in
                owner.showExpiredTokenAlert()
            }.disposed(by: disposeBag)
        
        output.toastMessage
            .asSignal()
            .emit(with: self) { owner, value in
                owner.showToast(message: value)
            }.disposed(by: disposeBag)
    }
}
