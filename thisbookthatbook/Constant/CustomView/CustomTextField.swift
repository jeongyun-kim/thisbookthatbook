//
//  CustomTextField.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/14/24.
//

import UIKit
import SnapKit

final class CustomTextField: UITextField {
    
    init(_ placeHolder: String) {
        super.init(frame: .zero)
        placeholder = placeHolder
        
        leftViewMode = .always
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 56))
        leftView = view
        layer.borderWidth = 1
        layer.borderColor = Resource.Colors.lightGray.cgColor
        layer.cornerRadius = Resource.Radius.normal
        
        snp.makeConstraints { make in
            make.height.equalTo(56)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
