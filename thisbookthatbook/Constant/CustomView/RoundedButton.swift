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
    }
    
    init(type: ButtonType = .validate, font: UIFont = Resource.Fonts.regular15) {
        super.init(frame: .zero)
        
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = Resource.Colors.gray6
        config.baseForegroundColor = Resource.Colors.black
        config.attributedTitle = AttributedString("button_title_validate".localized, attributes: AttributeContainer([.font: font]))
        config.cornerStyle = .medium
        configuration = config
        
        isEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
