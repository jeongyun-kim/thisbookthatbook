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
    
    struct Input {
        let nickname: ControlProperty<String>
        let validateBtnTapped: ControlEvent<Void>
    }
    
    struct Output {
        let userProfile: BehaviorRelay<UserProfile?>
        let toastMessage: PublishRelay<String>
        let alert: PublishRelay<Void>
        let validationEnabled: PublishRelay<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        let outputProfile = BehaviorRelay<UserProfile?>(value: nil)
        let toastMessage = PublishRelay<String>()
        let alert = PublishRelay<Void>()
        let nickname = BehaviorRelay(value: "")
        let validationEnabled = PublishRelay<Bool>()
        
        profile
            .compactMap { $0 }
            .bind(to: outputProfile)
            .disposed(by: disposeBag)
        
        input.nickname
            .bind(to: nickname)
            .disposed(by: disposeBag)
        
        input.nickname
            .map { $0.trimmingCharacters(in: .whitespaces).count }
            .map { $0 >= 2 && $0 <= 10}
            .bind(to: validationEnabled)
            .disposed(by: disposeBag)
        
        input.validateBtnTapped
            .throttle(.seconds(5), scheduler: MainScheduler.instance)
            .withLatestFrom(nickname)
            .flatMap { NetworkService.shared.postSignUp(email: "", password: "", nickname: $0) }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let value):
                    print(value)
                case .failure(let error):
                    print(error)
                }
            }.disposed(by: disposeBag)
        
        
        
        let output = Output(userProfile: outputProfile, toastMessage: toastMessage, alert: alert, validationEnabled: validationEnabled)
        return output
    }
}
