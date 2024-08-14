//
//  Alert.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/14/24.
//

import Foundation

extension Resource {
    enum AlertActionType {
        static let confirm = "alert_confirm"
        static let cancel = "alert_cancel"
    }
    
    enum Alert {
        case withdraw
        case expiredToken
        
        var title: String {
            switch self {
            case .withdraw:
                return "alert_title_withdraw"
            case .expiredToken:
                return "alert_title_expiredToken"
            }
        }
        
        var message: String {
            switch self {
            case .withdraw:
                return "alert_msg_withdraw"
            case .expiredToken:
                return "alert_msg_expiredToken"
            }
        }
    }
}
