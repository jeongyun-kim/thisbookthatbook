//
//  CustomBorder.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/20/24.
//

import UIKit
import SnapKit

final class CustomBorder: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        backgroundColor = Resource.Colors.gray6
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
