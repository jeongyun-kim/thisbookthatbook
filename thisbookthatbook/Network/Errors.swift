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
        
        case invalidPost = "toast_create_post_error"
        case invalidPostRequest = "alert_invalid_post"
        
        case invalidDeletePostRequest = "toast_delete_invalidPost"
        
        case invalidLikePostRequest = "toast_like_invalidRequest"
        
        case emptyContent = "toast_comment_empty"
        case invalidDeleteCommentRequest = "toast_delete_inavlidComment"
        
        case invalidPayRequest = "toast_pay_invalid"
        case noPostToPay = "toast_pay_no_post"
        
        case existNickname = "toast_profile_exist_nickname"
    }
}
