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
        tableView.rowHeight = 80
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.register(PostHeaderView.self, forHeaderFooterViewReuseIdentifier: PostHeaderView.identifier)
        tableView.register(SearchBookTableViewCell.self, forCellReuseIdentifier: SearchBookTableViewCell.identifier)
        return tableView
    }()
    
    override func setupHierarchy() {
        addSubview(commentTableView)
    }
    
    override func setupConstraints() {
        commentTableView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
