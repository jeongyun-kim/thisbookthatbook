//
//  SignupQuery.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/14/24.
//

import Foundation

struct SignupQuery: Encodable {
    let email: String
    let password: String
    let nick: String
}
