//
//  UploadPostQuery.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/17/24.
//

import Foundation

struct UploadPostQuery: Encodable {
    var title: String
    var content: String
    var content1: String
    var content2: String
    var content3: String
    var content4: String
    var content5: String
    var product_id: String
    var price: Int
    var files: [String]
    
    init(content: String, content1: String, content2: String, content3: String, content4: String, content5: String, product_id: RecommendType, price: Int, files: [String]) {
        self.title = "tbtb_post"
        self.content = content
        self.content1 = content1
        self.content2 = content2
        self.content3 = content3
        self.content4 = content4
        self.content5 = content5
        self.product_id = product_id.rawValue
        self.price = price
        self.files = files
    }
}
