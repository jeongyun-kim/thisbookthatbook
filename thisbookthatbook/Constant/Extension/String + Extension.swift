//
//  String + Extension.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/14/24.
//

import Foundation

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    var validationEmail: Bool {
    
        // 이메일 입력칸 유효성 확인
        // - [A-Z0-9a-z._%+-]: 대소문자, 숫자, 특수문자 사용 가능
        // - +@: []과 []사이에 @가 필수로 들어가게
        // - [A-Za-z0-9.-]: 대소문자, 숫자 사용 가능
        // - +\\.: []과 []사이에 .가 필수로 들어가게
        // -[A-Za-z]: 대소문자 사용 가능
        // - {2,6}: 앞의 [A-Za-z]를 2~6자리로 제한
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let result = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
        return result
    }
}
