//
//  ProfileEditView.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/27/24.
//

import UIKit
import SnapKit

final class ProfileEditView: BaseView {
    private let profileImageView = UserProfileImageView(size: .editProfileView)
    
    let nicknameTextField = CustomTextField(.nickname)
    
    let nicknameValidationLabel: UILabel = {
        let label = UILabel()
        label.font = Resource.Fonts.regular14
        label.text = "label_nickname_condition".localized
        return label
    }()
    
    let validateButton = ValidateButton()
    
    let saveButton = NextButton(title: .save)
    
    override func setupHierarchy() {
        addSubview(profileImageView)
        addSubview(nicknameTextField)
        addSubview(validateButton)
        addSubview(nicknameValidationLabel)
        addSubview(saveButton)
    }
    
    override func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.centerX.equalTo(safeAreaLayoutGuide)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(24)
            make.leading.equalTo(safeAreaLayoutGuide).offset(24)
        }
        
        validateButton.snp.makeConstraints { make in
            make.height.equalTo(nicknameTextField.snp.height)
            make.centerY.equalTo(nicknameTextField.snp.centerY)
            make.leading.equalTo(nicknameTextField.snp.trailing).offset(6)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(24)
        }
        
        nicknameValidationLabel.snp.makeConstraints { make in
            make.leading.equalTo(nicknameTextField.snp.leading).offset(6)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(8)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameValidationLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
        }
    }
}
