//
//  ContentsType.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/26/24.
//

import Foundation

enum UserContentsType: String, CaseIterable {
    case post = "user_contents_posts"
    case like = "user_contents_like"
    case bookmark = "user_contents_bookmark"
}

enum RecommendType: String, CaseIterable {
    case give_recommend = "tbtb_recommend"
    case recieve_recommended = "tbtb_recommended"
}
