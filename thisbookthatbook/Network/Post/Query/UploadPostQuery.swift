//
//  UploadPostQuery.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/17/24.
//

import Foundation

enum RecommendType: String {
    case give_recommend = "tbtb_recommend"
    case recieve_recommended = "tbtb_recommended"
}

struct UploadPostQuery: Encodable {
    var content: String
    var content1: String
    var content2: String
    var content3: String
    var content4: String
    var content5: String
    var product_id: String
    var files: [String]
    
    init(content: String, content1: String, content2: String, content3: String, content4: String, content5: String, product_id: RecommendType, files: [String]) {
        self.content = content
        self.content1 = content1
        self.content2 = content2
        self.content3 = content3
        self.content4 = content4
        self.content5 = content5
        self.product_id = product_id.rawValue
        self.files = files
    }
}
