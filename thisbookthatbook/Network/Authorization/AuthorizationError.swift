//
//  AuthorizationError.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/14/24.
//

import Foundation

enum AuthorizationError {
    enum LoginError: String, Error {
        case defaultError = "toast_default_error"
        case emptyData = "toast_login_empty"
        case invalidData = "toast_login_error"
    }
    
    enum RefreshTokenError: String, Error {
        case defaultError = "toast_default_error"
        case invalidToken
        case forbidden
        case expiredToken = "alert_msg_expiredToken"
    }
    
    enum SignupError: String, Error {
        case defaultError = "toast_default_error"
        case existUser = "toast_signup_exist"
    }
    
    enum EmailValidationError: String, Error {
        case defaultError = "toast_default_error"
        case invalidEmail = "label_email_invalid"
    }
    
    enum WithdrawError: String, Error {
        case defaultError = "toast_default_error"
    }
}

