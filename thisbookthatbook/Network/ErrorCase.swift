//
//  ErrorCase.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/14/24.
//

import Foundation

enum ErrorCase {
    enum LoginError: String, Error {
        case emptyData = "toast_login_empty"
        case invalidData = "toast_login_error"
    }
    
    enum RefreshTokenError: String, Error {
        case invalidToken
        case forbidden
        case expiredToken = "alert_msg_expiredToken"
    }
    
    enum SignupError: String, Error {
        case existUser = "toast_signup_exist"
        case emptyData = "toast_signup_empty"
    }
}

