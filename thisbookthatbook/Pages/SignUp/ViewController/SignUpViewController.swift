//
//  SignUpViewController.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/14/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SignUpViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    private let main = SignUpView()
    private let vm = SignUpViewModel()
    
    override func loadView() {
        self.view = main
    }
    
    override func setupUI() {
        super.setupUI()
        navigationItem.title = "navigation_title_signup".localized
    }
    
    override func bind() {
        let nickname = main.nicknameTextField.rx.text.orEmpty
        let email = main.emailTextField.rx.text.orEmpty
        let password = main.passwordTextField.rx.text.orEmpty
        let validateBtnTapped = main.emailValidateButton.rx.tap
        let signupBtnTapped = main.signUpButton.rx.tap
        
        let input = SignUpViewModel.Input(nickname: nickname, email: email, password: password, validateBtnTapped: validateBtnTapped, signupBtnTapped: signupBtnTapped)
        let output = vm.transform(input)
        
        // 닉네임 조건 확인 결과
        // - 2자 이상 10자 이하
        output.nicknameValidation
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, value in
                owner.configureTextField(owner.main.nicknameTextField, value: value)
            }.disposed(by: disposeBag)
        
        // 이메일 형식 확인 -> 중복확인 버튼 활성화 여부 결정
        output.emailRegexValidation
            .asDriver(onErrorJustReturn: false)
            .drive(main.emailValidateButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        // 이메일 중복확인 결과
        output.emailValidation
            .asDriver(onErrorJustReturn: (false, ""))
            .drive(with: self) { owner, value in
                owner.configureTextField(owner.main.emailTextField, value: value.0)
                owner.main.emailValidationLabel.text = value.1
            }.disposed(by: disposeBag)
        
        // 비밀번호 조건 확인 결과
        // - 공백없이 4자 이상 15자 이하 
        output.passwordValidation
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, value in
                owner.configureTextField(owner.main.passwordTextField, value: value)
            }.disposed(by: disposeBag)
        
        // 이메일 / 비밀번호 유효성 결과 
        output.totalValidation
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                let color = value ? Resource.Colors.primaryColor : Resource.Colors.lightGray
                owner.main.signUpButton.backgroundColor = color
                owner.main.signUpButton.isEnabled = value
            })
            .disposed(by: disposeBag)
        
        // 토스트메시지 띄우기
        output.toastMessage
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, value in
                owner.showToast(message: value)
            }.disposed(by: disposeBag)
        
        // 로그인하게 이전 화면으로 사용자 보내기 
        output.popViewController
            .asSignal()
            .emit(with: self) { owner, _ in
                owner.showAlertOnlyConfirm(message: "alert_msg_signup_success".localized) { _ in
                    owner.navigationController?.popViewController(animated: true)
                }
            }.disposed(by: disposeBag)
    }
    
    private func configureTextField(_ textField: UITextField, value: Bool) {
        let color: UIColor = value ? Resource.Colors.primaryColor : Resource.Colors.red
        textField.layer.borderColor = color.cgColor
    }
}
