//
//  Withdraw.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/15/24.
//

import Foundation

struct Withdraw: Decodable {
    let id: String
    let email: String
    let nickname: String
    
    enum CodingKeys: String,CodingKey {
        case id = "user_id"
        case email
        case nickname = "nick"
    }
}
