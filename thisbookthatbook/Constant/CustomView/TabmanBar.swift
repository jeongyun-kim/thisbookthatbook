//
//  TabmanBar.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/26/24.
//

import Foundation
import Tabman
import SnapKit


final class TabmanBar: TMBar.ButtonBar {
    
    required init() {
        super.init()
        setupUI()
        
        snp.makeConstraints { make in
            make.height.equalTo(44)
        }
    }
    
    private func setupUI() {
        backgroundView.style = .clear
        layout.transitionStyle = .snap
        layout.alignment = .leading
        layout.contentMode = .intrinsic
        layout.interButtonSpacing = 24
    
        buttons.customize { button in
            button.tintColor = Resource.Colors.lightGray
            button.selectedTintColor = Resource.Colors.black
            button.font = Resource.Fonts.regular15
            button.selectedFont = Resource.Fonts.bold15
        }
   
        indicator.weight = .custom(value: 3)
        indicator.overscrollBehavior = .compress
        indicator.tintColor = Resource.Colors.primaryColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

