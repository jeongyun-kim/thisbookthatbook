//
//  Posts.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/17/24.
//

import Foundation

struct Posts: Decodable {
    let data: [Post]
}

struct Post: Decodable {
    let post_id: String
    let product_id: String
    let content: String?
    let content1: String?
    let content2: String?
    let content3: String?
    let content4: String?
    let content5: String?
    let createdAt: String
    let creator: User
    let files: [String]
    let likes: [String]
    let likes2: [String]
    let hashTags: [String]
    let buyers: [String]
    let comments: [Comment]
}

extension Post {
    var isLikePost: Bool {
        let myId = UserDefaultsManager.shared.id
        return likes.contains(myId)
    }
    
    var hashtags: [String] {
        return hashTags.map { "#\($0)" }
    }
    
    var books: [String] {
        let contents = [content1, content2, content3, content4, content5]
        return contents.compactMap { $0 }.filter { !$0.isEmpty }
    }
}
