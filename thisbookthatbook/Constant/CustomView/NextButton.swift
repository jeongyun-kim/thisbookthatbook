//
//  NextButton.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/15/24.
//

import UIKit
import SnapKit

final class NextButton: UIButton {
    
    init(title: Resource.ButtonTitle){
        super.init(frame: .zero)
        layer.cornerRadius = Resource.Radius.normal
        setTitle(title.rawValue.localized, for: .normal)
        titleLabel?.font = Resource.Fonts.bold18
        backgroundColor = Resource.Colors.primaryColor
        
        snp.makeConstraints { make in
            make.height.equalTo(56)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
