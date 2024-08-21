//
//  Book.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/21/24.
//

import Foundation

struct BookSearchResult: Decodable {
    let total: Int
    let items: [Book]
}

struct Book: Decodable {
    let title: String
    let image: String
    let author: String
    let publisher: String
    let pubdate: String
    let isbn: String
    let description: String
}
