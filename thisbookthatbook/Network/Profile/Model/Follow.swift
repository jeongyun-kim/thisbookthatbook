//
//  Follow.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/31/24.
//

import Foundation

struct Follow: Decodable {
    let nick: String
    let opponent_nick: String
    let following_status: Bool
}
