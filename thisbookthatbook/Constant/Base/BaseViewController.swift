//
//  BaseViewController.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/13/24.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupConstraints()
        setupUI()
        bind()
    }
    
    func setupHierarchy() {
        
    }
    
    func setupConstraints() {
        
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.backButtonDisplayMode = .minimal
        navigationController?.navigationBar.tintColor = Resource.Colors.primaryColor
    }
    
    func bind() {
        
    }
}
