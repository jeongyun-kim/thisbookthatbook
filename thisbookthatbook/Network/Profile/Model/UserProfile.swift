//
//  UserProfile.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/26/24.
//

import Foundation

struct UserProfile: Decodable {
    let userId: String
    let email: String
    let nickname: String
    let profileImage: String?
    let followers: [User]
    let following: [User]
    let posts: [String]
    
    enum CodingKeys: String,CodingKey {
        case userId = "user_id"
        case email
        case nickname = "nick"
        case profileImage
        case followers
        case following
        case posts
    }
}
