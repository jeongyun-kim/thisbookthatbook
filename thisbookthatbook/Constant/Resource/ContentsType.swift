//
//  ContentsType.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/26/24.
//

import Foundation

enum PostFilterType: String, CaseIterable {
    case post = "user_contents_posts"
    case like = "user_contents_like"
    case bookmark = "user_contents_bookmark"
}

enum RecommendType: String, CaseIterable {
    case give_recommend = "tbtb_recommend"
    case recieve_recommended = "tbtb_recommended"
}

enum PostViewType {
    case add
    case edit
    
    var navigationTitle: String {
        switch self {
        case .add:
            return "navigation_title_add"
        case .edit:
            return "포스트 수정"
        }
    }
    
    var rightBarTitle: String {
        switch self {
        case .add:
            return "게시"
        case .edit:
            return "저장"
        }
    }
}
