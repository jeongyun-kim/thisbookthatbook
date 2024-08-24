//
//  User.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/24/24.
//

import Foundation

struct User: Decodable {
    let user_id: String
    let nick: String
    let profileImage: String?
}
