//
//  ValidateButton.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/27/24.
//

import UIKit
import SnapKit

final class RoundedButton: UIButton {
    enum ButtonType: String {
        case validate = "button_title_validate"
        case pay = "button_title_pay"
        case follow = "팔로우"
        case following = "팔로잉"
        
        var font: UIFont {
            switch self {
            case .follow:
                return Resource.Fonts.regular13
            case .following:
                return Resource.Fonts.bold13
            case .validate:
                return Resource.Fonts.regular15
            case .pay:
                return Resource.Fonts.regular14
            }
        }
    }
    
    init(type: ButtonType = .validate) {
        super.init(frame: .zero)
        
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = Resource.Colors.gray6
        config.baseForegroundColor = Resource.Colors.black
        config.attributedTitle = AttributedString(type.rawValue.localized, attributes: AttributeContainer([.font: type.font]))
        config.cornerStyle = .medium
        configuration = config
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
