//
//  SignUpView.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/15/24.
//

import UIKit
import SnapKit

final class SignUpView: BaseView {
    let nicknameTextField = CustomTextField(.nickname)
    
    let nicknameValidationLabel: UILabel = {
        let label = UILabel()
        label.font = Resource.Fonts.regular14
        label.text = "label_nickname_condition".localized
        return label
    }()
    
    let emailTextField = CustomTextField(.email)
    
    let emailValidateButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = Resource.Colors.gray6
        config.baseForegroundColor = Resource.Colors.black
        config.attributedTitle = AttributedString("button_title_check_email".localized, attributes: AttributeContainer([.font: Resource.Fonts.regular15]))
        config.cornerStyle = .medium
        button.configuration = config
        button.isEnabled = false
        return button
    }()
    
    let emailValidationLabel: UILabel = {
        let label = UILabel()
        label.font = Resource.Fonts.regular14
        return label
    }()
    
    let passwordTextField: UITextField = {
        let textField = CustomTextField(.password)
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let passwordValidationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = "label_password_condition".localized
        label.font = Resource.Fonts.regular14
        return label
    }()
    
    let signUpButton: UIButton = {
        let button = NextButton(title: .signup)
        button.isEnabled = false
        return button
    }()
    
    override func setupHierarchy() {
        addSubview(nicknameTextField)
        addSubview(nicknameValidationLabel)
        addSubview(emailTextField)
        addSubview(emailValidateButton)
        addSubview(emailValidationLabel)
        addSubview(passwordTextField)
        addSubview(passwordValidationLabel)
        addSubview(signUpButton)
    }
    
    override func setupConstraints() {
        nicknameTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
            make.top.equalTo(safeAreaLayoutGuide).offset(30)
        }
        
        nicknameValidationLabel.snp.makeConstraints { make in
            make.leading.equalTo(nicknameTextField.snp.leading).offset(6)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(8)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
            make.top.equalTo(nicknameValidationLabel.snp.bottom).offset(28)
        }
        
        emailValidateButton.snp.makeConstraints { make in
            make.centerY.equalTo(emailTextField)
            make.leading.equalTo(emailTextField.snp.trailing).offset(12)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(16)
            make.height.equalTo(emailTextField.snp.height)
        }
        
        emailValidationLabel.snp.makeConstraints { make in
            make.leading.equalTo(emailTextField.snp.leading).offset(6)
            make.top.equalTo(emailTextField.snp.bottom).offset(8)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(emailTextField.snp.height)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
            make.top.equalTo(emailValidationLabel.snp.bottom).offset(28)
        }
        
        passwordValidationLabel.snp.makeConstraints { make in
            make.leading.equalTo(passwordTextField.snp.leading).offset(6)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(16)
            make.top.equalTo(passwordTextField.snp.bottom).offset(8)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
            make.top.equalTo(passwordTextField.snp.bottom).offset(60)
        }
    }
}
