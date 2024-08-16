//
//  SignUpViewModel.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/15/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SignUpViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let nickname: ControlProperty<String>
        let email: ControlProperty<String>
        let password: ControlProperty<String>
        let validateBtnTapped: ControlEvent<Void>
        let signupBtnTapped: ControlEvent<Void>
    }
    
    struct Output {
        let nicknameValidation: PublishRelay<Bool> // 닉네임 유효성
        let emailRegexValidation: PublishRelay<Bool> // 이메일 형식 확인 결과
        let emailValidation: PublishRelay<(Bool, String)> // 이메일 중복확인 결과
        let passwordValidation: PublishRelay<Bool> // 비밀번호 유효성
        let totalValidation: BehaviorRelay<Bool> // 닉네임, 이메일, 비밀번호 유효성 결과
        let toastMessage: PublishRelay<String> // 에러 메시지
        let popViewController: PublishRelay<Void> // 회원가입 성공 시 
    }
    
    func transform(_ input: Input) -> Output {
        let email = BehaviorRelay(value: "")
        let password = BehaviorRelay(value: "")
        let nickname = BehaviorRelay(value: "")
        
        let nicknameValidation = PublishRelay<Bool>()
        let emailRegexValidation = PublishRelay<Bool>()
        let passwordValidation = PublishRelay<Bool>()
        let emailValidation = PublishRelay<(Bool, String)>()
        let totalValidation = BehaviorRelay(value: false)
        let toastMessage = PublishRelay<String>()
        let popViewController = PublishRelay<Void>()
        
        input.nickname
            .bind(to: nickname)
            .disposed(by: disposeBag)
        
        input.email
            .bind(to: email)
            .disposed(by: disposeBag)
        
        input.password
            .bind(to: password)
            .disposed(by: disposeBag)
        
        // 닉네임 입력 시마다 조건 충족 여부 확인
        input.nickname
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .map { $0.count >= 2 && $0.count <= 10 }
            .bind(to: nicknameValidation)
            .disposed(by: disposeBag)
        
        // 이메일 입력 시마다 조건 충족 여부 확인
        input.email
            .map { $0.validationEmail }
            .bind(to: emailRegexValidation)
            .disposed(by: disposeBag)
        
        // 비밀번호 입력 시마다 조건 충족 여부 확인
        input.password
            .map {
                !$0.contains(" ")
                && $0.trimmingCharacters(in: .whitespaces).count >= 4
                && $0.trimmingCharacters(in: .whitespaces).count <= 15
            }
            .bind(to: passwordValidation)
            .disposed(by: disposeBag)
        
        // 중복확인 버튼 눌렀을 때
        input.validateBtnTapped
            .throttle(.seconds(5), scheduler: MainScheduler.instance)
            .withLatestFrom(input.email)
            .flatMap { NetworkService.shared.postValidateEmail(email: $0) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(_):
                    emailValidation.accept((true, "label_email_valid".localized))
                case .failure(let error):
                    emailValidation.accept((false, error.rawValue.localized))
                }
            }.disposed(by: disposeBag)
        
        // 닉네임 / 이메일 / 비밀번호 모두 조건을 충족하는지
        Observable
            .combineLatest(nicknameValidation, emailValidation, passwordValidation)
            .map { $0.0 && $0.1.0 && $0.2 }
            .bind(to: totalValidation)
            .disposed(by: disposeBag)
        
        // 회원가입 버튼 눌렀을 때
        input.signupBtnTapped
            .throttle(.seconds(5), scheduler: MainScheduler.instance)
            .flatMap { NetworkService.shared.postSignUp(email: email.value, password: password.value, nickname: nickname.value) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    // 성공했다면 이전 화면에서 로그인하라고 알려주기
                    popViewController.accept(())
                case .failure(let error):
                    // 실패했다면 에러 메시지 띄우기
                    toastMessage.accept(error.rawValue.localized)
                }
            }.disposed(by: disposeBag)
  
        return Output(nicknameValidation: nicknameValidation, emailRegexValidation: emailRegexValidation, emailValidation: emailValidation, passwordValidation: passwordValidation, totalValidation: totalValidation, toastMessage: toastMessage, popViewController: popViewController)
    }
}
