//
//  WritePostView.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/19/24.
//

import UIKit
import SnapKit

final class WritePostView: BaseView {
    private let contentTextView = UITextView()
    
    override func setupHierarchy() {
        addSubview(contentTextView)
    }
    
    override func setupConstraints() {
        contentTextView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide).inset(16)
        }
    }
    
    override func setupUI() {
        contentTextView.text = "placeholder_write_post".localized
        contentTextView.font = Resource.Fonts.regular15
    }
}
