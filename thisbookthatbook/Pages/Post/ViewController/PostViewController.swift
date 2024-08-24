//
//  PostViewController.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/23/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PostViewController: BaseViewController {
    init(postId: String) {
        super.init(nibName: nil, bundle: nil)
        vm.postId.accept(postId)
    }
    
    private let main = PostView()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = main
    }
    
    private var vm = PostViewModel()
    
    override func setupUI() {
        super.setupUI()
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "navigation_title_detail_post".localized
        main.commentTableView.delegate = self
        main.commentTableView.dataSource = self
        tabBarController?.tabBar.isHidden = true
    }
    
    override func bind() {
        // 에러 처리
        vm.isExpiredTokenError
            .asSignal()
            .emit(with: self) { owner, value in
                if value {
                    owner.showExpiredTokenAlert()
                } else {
                    owner.showAlertOnlyConfirm(title: "alert_title_failed_get_post".localized, message: "alert_msg_failed_get_post".localized) { _ in
                        owner.navigationController?.popViewController(animated: true)
                    }
                }
            }.disposed(by: disposeBag)
        
        // 네트워크 통신으로 데이터 들어오면 tableview reload
        vm.postData
            .bind(with: self) { owner, value in
                owner.main.commentTableView.reloadData()
            }.disposed(by: disposeBag)
        
        main.commentInputView.commentTextField.rx.controlEvent(.editingDidEndOnExit)
            .withLatestFrom(main.commentInputView.commentTextField.rx.text.orEmpty)
            .filter { !$0.isEmpty }
            .map { NetworkService.shared.postComment(self.vm.postData.value!.post_id, query: $0) }
            .bind(with: self) { owner, _ in
                print("tapped")
            }.disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UITableViewExtension
extension PostViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let data = vm.postData.value else { return 0 }
        return data.comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as? CommentTableViewCell else { return UITableViewCell() }
        guard let data = vm.postData.value else { return cell }
        let comment = data.comments[indexPath.row]
        cell.configureCell(comment)
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: PostHeaderView.identifier) as? PostHeaderView else { return nil }
        guard let data = vm.postData.value else { return nil }
        header.configureView(data)
        return header
    }
}

