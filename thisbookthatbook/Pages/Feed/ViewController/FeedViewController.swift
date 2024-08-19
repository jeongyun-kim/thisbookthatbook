//
//  FeedViewController.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/13/24.
//

import UIKit
import RxSwift
import RxCocoa

final class FeedViewController: BaseViewController {
    private let main = FeedView()
    private let disposeBag = DisposeBag()
    private let vm = FeedViewModel()
    
    override func loadView() {
        self.view = main
    }

    override func setupUI() {
        super.setupUI()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "navigation_title_feed".localized
    }
    
    override func bind() {
        let selectedSegentIdx = main.segmentControl.rx.selectedSegmentIndex
        
        let input = FeedViewModel.Input(selectedSegmentIdx: selectedSegentIdx)
        let output = vm.transform(input)
        
        // 포스트 조회 결과
        output.feedResults
            .asDriver(onErrorJustReturn: [])
            .drive(main.collectionView.rx.items(cellIdentifier: FeedCollectionViewCell.identifier, cellType: FeedCollectionViewCell.self)) { (row, element, cell) in
                cell.configureCell(element)
                // 책 데이터만 가져와서 내부 컬렉션뷰에 보여주기
                let books = [element.content1, element.content2, element.content3, element.content4, element.content5]
                let data = books.compactMap { $0 }.filter { !$0.isEmpty }
                Observable.just(data)
                    .bind(to: cell.bookCollectionView.rx.items(cellIdentifier: BookCollectionViewCell.identifier, cellType: BookCollectionViewCell.self)) { (row, element, cell) in
                        cell.configureCell(element)
                    }.disposed(by: cell.disposeBag)
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
                let title = "alert_title_expiredToken".localized
                let message = "alert_msg_expiredToken".localized
                owner.showAlertOnlyConfirm(title: title, message: message) { _ in
                    let vc = UINavigationController(rootViewController: LoginViewController())
                    owner.setNewScene(vc)
                }
            }.disposed(by: disposeBag)
    }
}
