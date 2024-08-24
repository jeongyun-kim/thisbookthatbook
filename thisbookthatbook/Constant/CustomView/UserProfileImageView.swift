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
    }
    
    init(size: ProfileSize = .feed) {
        super.init(frame: .zero)
        image = UIImage(named: "user")
        clipsToBounds = true
        layer.cornerRadius = size.rawValue / 2
        
        snp.makeConstraints { make in
            make.size.equalTo(size.rawValue)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
