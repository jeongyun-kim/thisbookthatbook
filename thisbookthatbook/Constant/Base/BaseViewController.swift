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
        navigationController?.navigationBar.tintColor = Resource.Colors.black
    }
    
    func bind() {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func showExpiredTokenAlert() {
        let title = "alert_title_expiredToken".localized
        let message = "alert_msg_expiredToken".localized
        showAlertOnlyConfirm(title: title, message: message) { [weak self] _ in
            guard let self else { return }
            let vc = UINavigationController(rootViewController: LoginViewController())
            self.setNewScene(vc)
        }
    }
}
