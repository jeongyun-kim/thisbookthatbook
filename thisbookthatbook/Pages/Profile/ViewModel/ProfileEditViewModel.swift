//
//  ProfileEditViewModel.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/27/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfileEditViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    
    let profile = BehaviorRelay<UserProfile?>(value: nil)
    let profileImage = BehaviorRelay<Data?>(value: nil)
    
    struct Input {
        let nickname: ControlProperty<String>
        let validateBtnTapped: ControlEvent<Void>
        let saveBtnTapped: ControlEvent<Void>
        let profileBtnTapped: ControlEvent<Void>
        let withdrawBtnTapped: PublishRelay<Void>
    }
    
    struct Output {
        let userProfile: BehaviorRelay<UserProfile?>
        let toastMessage: PublishRelay<String>
        let alert: PublishRelay<Void>
        let editEnabled: PublishRelay<Bool>
        let profileBtnTapped: ControlEvent<Void>
        let editProfileSucceed: PublishRelay<Void>
        let withdrawSucceed: PublishRelay<Void>
    }
    
    func transform(_ input: Input) -> Output {
        let outputProfile = BehaviorRelay<UserProfile?>(value: nil)
        let toastMessage = PublishRelay<String>()
        let alert = PublishRelay<Void>()
        let nickname = BehaviorRelay(value: "")
        let editEnabled = PublishRelay<Bool>()
        let editProfileSucceed = PublishRelay<Void>()
        let withdrawSucceed = PublishRelay<Void>()
        
        // 이전 뷰로부터 받아온 프로필 정보
        profile
            .compactMap { $0 }
            .bind(to: outputProfile)
            .disposed(by: disposeBag)
        
        // 닉네임 입력 시마다 입력한 닉네임 저장
        input.nickname
            .bind(to: nickname)
            .disposed(by: disposeBag)
        
        // 현재 입력한 닉네임이 닉네임 조건에 맞는지 확인
        nickname
            .map { $0.trimmingCharacters(in: .whitespaces).count }
            .map { $0 >= 2 && $0 <= 10}
            .bind(to: editEnabled)
            .disposed(by: disposeBag)

        // 저장 버튼 눌렀을 때 서버 통신
        input.saveBtnTapped
            .map { [weak self] _ in (self?.profileImage.value, nickname.value) }
            .flatMap { NetworkService.shared.putEditProfile(profileImage: $0.0, nickname: $0.1) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(_):
                    editProfileSucceed.accept(())
                case .failure(let error):
                    switch error { // 토큰 에러 시 alert / 그 외는 토스트메시지 
                    case .expiredToken:
                        alert.accept(())
                    default:
                        toastMessage.accept(error.rawValue.localized)
                    }
                }
            }.disposed(by: disposeBag)
        
        input.withdrawBtnTapped
            .flatMap { NetworkService.shared.getWithDraw() }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(_):
                    withdrawSucceed.accept(())
                case .failure(let error):
                    switch error {
                    case .expiredToken:
                        alert.accept(())
                    default:
                        toastMessage.accept(error.rawValue.localized)
                    }
                }
            }.disposed(by: disposeBag)
    
        
        let output = Output(userProfile: outputProfile, toastMessage: toastMessage, 
                            alert: alert, editEnabled: editEnabled,
                            profileBtnTapped: input.profileBtnTapped, editProfileSucceed: editProfileSucceed,
                            withdrawSucceed: withdrawSucceed)
        return output
    }
}
