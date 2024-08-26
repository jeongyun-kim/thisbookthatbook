//
//  ProfileViewModel.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/26/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfileViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        
    }
    
    struct Output {
        let profile: PublishRelay<UserProfile>
        let toastMessage: PublishRelay<String>
        let alert: PublishRelay<Void>
    }
    
    func transform(_ input: Input) -> Output {
        let userProfile = PublishRelay<UserProfile>()
        let toastMessage = PublishRelay<String>()
        let alert = PublishRelay<Void>()
        
        Observable.just(1)
            .flatMap { _ in NetworkService.shared.getMyProfile() }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let value):
                    userProfile.accept(value)
                case .failure(let error):
                    switch error {
                    case .emptyContent:
                        alert.accept(())
                    default:
                        toastMessage.accept(error.rawValue.localized)
                    }
                }
            }.disposed(by: disposeBag)
        
        let output = Output(profile: userProfile, toastMessage: toastMessage, alert: alert)
        return output
    }
}