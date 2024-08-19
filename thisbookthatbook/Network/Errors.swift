//
//  Errors.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/16/24.
//

import Foundation

extension NetworkService {
    enum Errors: String, Error {
        case defaultError = "toast_default_error"
        
        case loginEmptyData = "toast_login_empty"
        case loginInvalidData = "toast_login_error"
        
        case expiredToken = "alert_msg_expiredToken"
        
        case signupExistUser = "toast_signup_exist"
        case signupInvalidEmail = "label_email_invalid"
        
        case postImageInvalidRequest
        
        case invalidDeletePostRequest = "toast_delete_invalidPost"
    }
}
