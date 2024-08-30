//
//  Reciept.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/30/24.
//

import Foundation

struct Reciept: Decodable {
    let buyerId: String
    let postId: String
    let merchantUID: String
    let productName: String?
    let price: Int
    let paidAt: String

    enum CodingKeys: String, CodingKey {
        case buyerId = "buyer_id"
        case postId = "post_id"
        case merchantUID = "merchant_uid"
        case productName
        case price
        case paidAt
    }
}
