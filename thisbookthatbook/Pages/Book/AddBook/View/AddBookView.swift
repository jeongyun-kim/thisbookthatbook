//
//  AddBookView.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/21/24.
//

import UIKit
import SnapKit

final class AddBookView: BaseView {
    let searchBar = CustomSearchBar("placeholder_search_books".localized)
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 140
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        tableView.allowsMultipleSelection = true
        tableView.register(SearchBookTableViewCell.self, forCellReuseIdentifier: SearchBookTableViewCell.identifier)
        return tableView
    }()
    
    override func setupHierarchy() {
        addSubview(searchBar)
        addSubview(tableView)
    }
    
    override func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(12)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
}
