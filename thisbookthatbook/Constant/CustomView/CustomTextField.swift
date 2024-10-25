//
//  CustomTextField.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/14/24.
//

import UIKit
import SnapKit

final class CustomTextField: UITextField {
    enum Placeholder: String {
        case email = "placeholder_email"
        case password = "placeholder_password"
        case nickname = "placeholder_nickname"
        case price = "placeholder_price"
    }
    
    init(_ placeHolder: Placeholder) {
        super.init(frame: .zero)
        placeholder = placeHolder.rawValue.localized
        
        leftViewMode = .always
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 56))
        leftView = view
        layer.borderWidth = 1
        layer.borderColor = Resource.Colors.lightGray.cgColor
        layer.cornerRadius = Resource.Radius.normal
        autocapitalizationType = .none
        autocorrectionType = .no
        
        snp.makeConstraints { make in
            make.height.equalTo(56)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
