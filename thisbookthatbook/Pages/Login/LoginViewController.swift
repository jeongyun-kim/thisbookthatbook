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

    private let emailTextField = CustomTextField(.email)
    private let passwordTextField = CustomTextField(.password)
    private let loginButton = NextButton(title: .login)
    private let signUpButton = UIButton()
    
    override func setupHierarchy() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(signUpButton)
    }
    
    override func setupConstraints() {
        emailTextField.snp.makeConstraints { make in
            make.centerY.equalTo(view.safeAreaLayoutGuide).offset(-120)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(emailTextField)
        }
        
        loginButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(passwordTextField)
            make.top.equalTo(passwordTextField.snp.bottom).offset(36)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(24)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func setupUI() {
        super.setupUI()
        emailTextField.spellCheckingType = .no
        passwordTextField.isSecureTextEntry = true
        let attributedTitle = NSAttributedString(string: "button_title_noUser".localized, attributes: [.font: Resource.Fonts.regular18])
        signUpButton.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    override func bind() {
        let email = emailTextField.rx.text.orEmpty
        let pw = passwordTextField.rx.text.orEmpty
        let loginBtnTapped = loginButton.rx.tap
        let signupBtnTapped = signUpButton.rx.tap
        
        let input = LoginViewModel.Input(email: email, pw: pw, loginBtnTapped: loginBtnTapped, signupBtnTapped: signupBtnTapped)
        let output = vm.transform(input)
        
        // 에러 시 토스트메시지
        output.toastMessage
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, message in
                owner.showToast(message: message)
            }.disposed(by: disposeBag)
        
        // 로그인 성공했을 때(true) FeedVC 불러오기 
        output.loginResult
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, value in
                guard value else { return }
                let vc = UINavigationController(rootViewController: TabBarController())
                owner.setNewScene(vc)
            }.disposed(by: disposeBag)
        
        // 회원가입 버튼 눌렀을 때
        output.signupBtnTapped
            .asSignal()
            .emit(with: self) { owner, _ in
                let vc = SignUpViewController()
                owner.transition(vc)
            }.disposed(by: disposeBag)
    }
}
