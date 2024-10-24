//
//  BaseView.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/13/24.
//

import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupConstraints()
        setupUI()
        configureView([])
    }
    
    func setupHierarchy() {
        
    }
    
    func setupConstraints() {
        
    }
    
    func setupUI() {
        
    }
    
    func configureView(_ thumbs: [String]) {

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
