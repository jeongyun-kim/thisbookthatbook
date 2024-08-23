//
//  CommentInputView.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/24/24.
//

import UIKit
import SnapKit

final class CommentInputView: BaseView {
    
    let commentTextField: UITextField = {
        let textField = UITextField()
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.backgroundColor = Resource.Colors.gray6
        textField.placeholder = "placeholder_comment".localized
        textField.font = Resource.Fonts.regular14
        textField.layer.cornerRadius = Resource.Radius.normal
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 1))
        textField.leftView = leftView
        textField.leftViewMode = .always
        return textField
    }()
    
    override func setupHierarchy() {
        addSubview(commentTextField)
    }
    
    override func setupConstraints() {
        commentTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
            make.verticalEdges.equalTo(safeAreaLayoutGuide).inset(8)
        }
    }
    
}
