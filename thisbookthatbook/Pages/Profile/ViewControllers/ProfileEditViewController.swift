//
//  ProfileEditViewController.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/27/24.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI

final class ProfileEditViewController: BaseViewController {
    init(vm: ProfileEditViewModel, profile: UserProfile) {
        super.init(nibName: nil, bundle: nil)
        self.vm = vm
        vm.profile.accept(profile)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private let main = ProfileEditView()
    
    private let disposeBag = DisposeBag()
    private var vm: ProfileEditViewModel!
    
    override func loadView() {
        super.view = main
    }
    
    override func setupUI() {
        super.setupUI()
        navigationItem.title = "navigation_title_edit_profile".localized
    }
    
    override func bind() {
        let nickname = main.nicknameTextField.rx.text.orEmpty
        let validateBtnTapped = main.validateButton.rx.tap
        let saveBtnTapped = main.saveButton.rx.tap
        let profileBtnTapped = main.profileButton.rx.tap
        
        let input = ProfileEditViewModel.Input(nickname: nickname, validateBtnTapped: validateBtnTapped,
                                               saveBtnTapped: saveBtnTapped, profileBtnTapped: profileBtnTapped)
        let output = vm.transform(input)
        
        // 사용자 프로필 정보
        output.userProfile
            .bind(with: self) { owner, value in
                guard let value else { return }
                owner.main.nicknameTextField.text = value.nickname
                owner.main.configureSavedProfileImage(value.profileImage)
            }.disposed(by: disposeBag)
        
        // 토큰 외 에러 시
        output.toastMessage
            .asSignal()
            .emit(with: self) { owner, value in
                owner.showToast(message: value)
            }.disposed(by: disposeBag)
        
        // 토큰 만료 시
        output.alert
            .asSignal()
            .emit(with: self) { owner, _ in
                owner.showExpiredTokenAlert()
            }.disposed(by: disposeBag)
        
        // 프로필 수정 저장 버튼 상태 (활성화/비활성화)
        output.editEnabled
            .bind(with: self, onNext: { owner, value in
                let color = value ? Resource.Colors.primaryColor : Resource.Colors.lightGray
                owner.main.saveButton.backgroundColor = color
                owner.main.saveButton.isEnabled = value
            }).disposed(by: disposeBag)
        
        // 성공적으로 프로필이 수정되었다면 이전 뷰로 
        output.editProfileSucceed
            .asSignal()
            .emit(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
        
        output.profileBtnTapped
            .asSignal()
            .emit(with: self) { owner, _ in
                let picker = owner.main.pickerViewController
                picker.delegate = owner
                owner.transition(picker, type: .present)
            }.disposed(by: disposeBag)
    }
}

extension ProfileEditViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { data, error in
                DispatchQueue.main.async {
                    guard let image = data as? UIImage else { return }
                    self.main.configureSelectedProfileImage(image)
                    self.vm.profileImage.accept(image.pngData())
                }
            }
        }
        dismiss(animated: true)
    }
  
}


