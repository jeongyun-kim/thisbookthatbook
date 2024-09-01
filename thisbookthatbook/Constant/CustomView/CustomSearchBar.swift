//
//  CustomSearchBar.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 9/1/24.
//

import UIKit
import SnapKit

final class CustomSearchBar: UISearchBar {
    
    init(_ text: String) {
        super.init(frame: .zero)
        
        searchBarStyle = .minimal
        backgroundColor = Resource.Colors.gray6
        placeholder = text
        layer.cornerRadius = Resource.Radius.normal
        searchTextField.borderStyle = .none
        searchTextField.backgroundColor = Resource.Colors.gray6
        
        snp.makeConstraints { make in
            make.height.equalTo(44)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
