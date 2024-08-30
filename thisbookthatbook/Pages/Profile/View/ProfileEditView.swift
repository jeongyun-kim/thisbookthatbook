//
//  ProfileEditView.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/27/24.
//

import UIKit
import Kingfisher
import PhotosUI
import SnapKit

final class ProfileEditView: BaseView {
    private let profileImageView = UserProfileImageView(size: .editProfileView)
    
    let profileButton = UIButton()
    
    let nicknameTextField = CustomTextField(.nickname)
    
    let nicknameValidationLabel: UILabel = {
        let label = UILabel()
        label.font = Resource.Fonts.regular14
        label.text = "label_nickname_condition".localized
        return label
    }()
    
    let validateButton = RoundedButton()
    
    let saveButton = NextButton(title: .save)
    
    let pickerViewController: PHPickerViewController = {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        let vc = PHPickerViewController(configuration: config)
        return vc
    }()

    override func setupHierarchy() {
        addSubview(profileImageView)
        addSubview(profileButton)
        addSubview(nicknameTextField)
        addSubview(nicknameValidationLabel)
        addSubview(saveButton)
    }
    
    override func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.centerX.equalTo(safeAreaLayoutGuide)
        }
        
        profileButton.snp.makeConstraints { make in
            make.edges.equalTo(profileImageView)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
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
    
    func configureSelectedProfileImage(_ image: UIImage?) {
        profileImageView.image = image
    }
    
    func configureSavedProfileImage(_ path: String?) {
        guard let path else { return }
        ImageFetcher.shared.getAnImageFromServer(path) { [weak self] imageData in
            self?.profileImageView.kf.setImage(with: imageData.url, options: [.requestModifier(imageData.modifier)])
        }
    }
}
