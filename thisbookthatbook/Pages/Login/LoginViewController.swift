//
//  LoginViewController.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/13/24.
//

import UIKit
import Alamofire
import RxSwift
import RxCocoa

final class LoginViewController: BaseViewController {
    private let vm = LoginViewModel()
    private let disposeBag = DisposeBag()

    private let emailTextField = CustomTextField(Resource.Placeholder.email.rawValue.localized)
    private let passwordTextField = CustomTextField(Resource.Placeholder.password.rawValue.localized)
    private let loginButton = UIButton()
    
    override func setupHierarchy() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
    }
    
    override func setupConstraints() {
        emailTextField.snp.makeConstraints { make in
            make.centerY.equalTo(view.safeAreaLayoutGuide).offset(-100)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(emailTextField)
        }
        
        loginButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(passwordTextField)
            make.top.equalTo(passwordTextField.snp.bottom).offset(36)
            make.height.equalTo(56)
        }
    }
    
    override func setupUI() {
        super.setupUI()
        emailTextField.spellCheckingType = .no
        passwordTextField.isSecureTextEntry = true
        loginButton.layer.cornerRadius = Resource.Radius.normal
        loginButton.setTitle(Resource.ButtonTitle.login.rawValue.localized, for: .normal)
        loginButton.titleLabel?.font = Resource.Fonts.bold18
        loginButton.backgroundColor = Resource.Colors.primaryColor
    }
    
    override func bind() {
        let email = emailTextField.rx.text.orEmpty
        let pw = passwordTextField.rx.text.orEmpty
        let loginBtnTapped = loginButton.rx.tap
        
        let input = LoginViewModel.Input(email: email, pw: pw, loginBtnTapped: loginBtnTapped)
        let output = vm.transform(input)
        
        // 에러 시 토스트메시지
        output.toastMessage
            .bind(with: self) { owner, message in
                owner.showToast(message: message)
            }.disposed(by: disposeBag)
        
        // 로그인 성공했을 때(true) FeedVC 불러오기 
        output.loginResult
            .bind(with: self) { owner, value in
                guard value else { return }
                let vc = UINavigationController(rootViewController: TabBarController())
                owner.setNewScene(vc)
            }.disposed(by: disposeBag)
    }
}
