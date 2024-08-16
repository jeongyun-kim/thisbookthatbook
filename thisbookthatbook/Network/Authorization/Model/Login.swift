//
//  Login.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/14/24.
//

import Foundation

struct Login: Decodable {
    let id: String
    let email: String
    let nick: String
    let profile: String?
    let accessToken: String
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case email
        case nick
        case profile = "profileImage"
        case accessToken
        case refreshToken
    }
}
