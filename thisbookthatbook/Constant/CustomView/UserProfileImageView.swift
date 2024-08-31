//
//  UserProfileImageView.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/24/24.
//

import UIKit
import SnapKit

final class UserProfileImageView: UIImageView {
    enum ProfileSize: CGFloat {
        case feed = 40
        case comment = 36
        case profileView = 70
        case editProfileView = 90
    }
    
    init(size: ProfileSize = .feed) {
        super.init(frame: .zero)
        image = Resource.Images.user
        clipsToBounds = true
        layer.cornerRadius = size.rawValue / 2
        layer.borderColor = Resource.Colors.gray6.withAlphaComponent(0.5).cgColor
        layer.borderWidth = 1
        
        snp.makeConstraints { make in
            make.size.equalTo(size.rawValue)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
