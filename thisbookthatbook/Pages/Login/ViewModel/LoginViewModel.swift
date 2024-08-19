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
        let loginResult: PublishRelay<Void?>
        let signupBtnTapped: ControlEvent<Void>
    }
    
    func transform(_ input: Input) -> Output {
        let email = BehaviorRelay(value: "")
        let pw = BehaviorRelay(value: "")
        let toastMessage = PublishRelay<String>()
        let fetchLogin = PublishRelay<Void>()
        let loginResult = PublishRelay<Void?>()
        
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
                    toastMessage.accept("toast_login_empty".localized)
                } else {
                    fetchLogin.accept(())
                }
            }.disposed(by: disposeBag)
        
        // 신호받으면 로그인 통신 실행 후 사용자 정보 저장 
        fetchLogin
            .flatMap { NetworkService.shared.postUserLogin(email: email.value, password: pw.value) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    loginResult.accept(())
                case .failure(let error):
                    toastMessage.accept(error.rawValue.localized)
                }
            }.disposed(by: disposeBag)
        
        return Output(toastMessage: toastMessage, loginResult: loginResult, signupBtnTapped: input.signupBtnTapped)
    }
    
    
}
