//
//  PlusButton.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/13/24.
//

import UIKit
import SnapKit

final class PlusButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Resource.Colors.primaryColor
        setImage(Resource.Images.plusImage, for: .normal)
        tintColor = Resource.Colors.white
        layer.cornerRadius = 28
        
        snp.makeConstraints { make in
            make.size.equalTo(56)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
