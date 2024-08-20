//
//  WritePostView.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/19/24.
//

import UIKit
import SnapKit

final class WritePostView: BaseView {
    let contentTextView = UITextView()
    
    private let toolbar = ToolbarView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
    
    override func setupHierarchy() {
        addSubview(contentTextView)
    }
    
    override func setupConstraints() {
        contentTextView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
            make.height.equalTo(400)
        }
    }
    
    override func setupUI() {
        contentTextView.text = "placeholder_write_post".localized
        contentTextView.font = Resource.Fonts.regular15
        contentTextView.textColor = Resource.Colors.lightGray
        contentTextView.autocorrectionType = .no
        contentTextView.spellCheckingType = .no
        contentTextView.inputAccessoryView = toolbar
    }
    
}
