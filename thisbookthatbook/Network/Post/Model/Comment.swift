//
//  Comment.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/24/24.
//

import Foundation

struct Comment: Decodable {
    let comment_id: String
    let content: String
    let createdAt: String
    let creator: User
}

extension Comment {
    var date: String {
        let dateArr = createdAt.components(separatedBy: "T")
        let result = dateArr[0].replacingOccurrences(of: "-", with: ".")
        return result
    }
}
