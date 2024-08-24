//
//  PostView.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/23/24.
//

import UIKit
import SnapKit

// 그 위 콘텐츠는 모두 헤더로 구성 
// 댓글을 tableview
final class PostView: BaseView {

    lazy var commentTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.keyboardDismissMode = .onDrag
        tableView.register(PostHeaderView.self, forHeaderFooterViewReuseIdentifier: PostHeaderView.identifier)
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        return tableView
    }()
    
    let commentInputView = CommentInputView()
    
    override func setupHierarchy() {
        addSubview(commentTableView)
        addSubview(commentInputView)
    }
    
    override func setupConstraints() {
        commentTableView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        commentInputView.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.top.equalTo(commentTableView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
