//
//  LoginViewModel.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/14/24.
//

import Foundation
import RxSwift
import RxCocoa

final class LoginViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    private let ud = UserDefaultsManager.shared
    
    struct Input {
        let email: ControlProperty<String>
        let pw: ControlProperty<String>
        let loginBtnTapped: ControlEvent<Void>
        let signupBtnTapped: ControlEvent<Void>
    }
    
    struct Output {
        let toastMessage: PublishRelay<String>
        let loginResult: PublishRelay<Bool>
        let signupBtnTapped: ControlEvent<Void>
    }
    
    func transform(_ input: Input) -> Output {
        let email = BehaviorRelay(value: "")
        let pw = BehaviorRelay(value: "")
        let toastMessage = PublishRelay<String>()
        let fetchLogin = PublishRelay<Void>()
        let loginResult = PublishRelay<Bool>()
        
        input.email
            .bind(to: email)
            .disposed(by: disposeBag)
        
        input.pw
            .bind(to: pw)
            .disposed(by: disposeBag)
        
        // 로그인 버튼 눌렀을 때 공백이면 토스트메시지 / 아니면 통신
        input.loginBtnTapped
            .throttle(.seconds(5), scheduler: MainScheduler.instance)
            .map { email.value.trimmingCharacters(in: .whitespaces).count > 0 && pw.value.trimmingCharacters(in: .whitespaces).count > 0 }
            .bind(with: self) { owner, value in
                if !value {
                    toastMessage.accept(Resource.Toast.emptyLoginData.rawValue.localized)
                } else {
                    fetchLogin.accept(())
                }
            }.disposed(by: disposeBag)
        
        // 신호받으면 로그인 통신 실행 후 사용자 정보 저장 
        fetchLogin
            .flatMap { NetworkService.shared.postUserLogin(model: Login.self, email: email.value, password: pw.value) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    owner.ud.accessToken = value.accessToken
                    owner.ud.refreshToken = value.refreshToken
                    owner.ud.nickname = value.nick
                    let profile = value.profile ?? ""
                    owner.ud.profile = profile
                    
                    loginResult.accept(true)
                case .failure(let error):
                    toastMessage.accept(error.rawValue.localized)
                }
            }.disposed(by: disposeBag)
        
        return Output(toastMessage: toastMessage, loginResult: loginResult, signupBtnTapped: input.signupBtnTapped)
    }
    
    
}
