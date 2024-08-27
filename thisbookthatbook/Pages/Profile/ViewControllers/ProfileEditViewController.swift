//
//  ProfileEditViewController.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/27/24.
//

import UIKit
import RxSwift
import RxCocoa

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
        
        let input = ProfileEditViewModel.Input(nickname: nickname, validateBtnTapped: validateBtnTapped)
        let output = vm.transform(input)
        
        output.userProfile
            .bind(with: self) { owner, value in
                guard let value else { return }
                owner.main.nicknameTextField.text = value.nickname
                owner.main.saveButton.isEnabled = true
                owner.main.validateButton.isEnabled = true
            }.disposed(by: disposeBag)
        
        output.toastMessage
            .asSignal()
            .emit(with: self) { owner, value in
                owner.showToast(message: value)
            }.disposed(by: disposeBag)
        
        output.alert
            .asSignal()
            .emit(with: self) { owner, _ in
                owner.showExpiredTokenAlert()
            }.disposed(by: disposeBag)
        
        output.validationEnabled
            .bind(to: main.validateButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}
