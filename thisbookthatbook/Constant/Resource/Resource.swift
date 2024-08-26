//
//  Resource.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/13/24.
//

import UIKit

enum Resource {
    enum Colors {
        static let primaryColor = UIColor(red: 0.63, green: 0.87, blue: 0.48, alpha: 1.00)
        static let pink = UIColor(red: 1.00, green: 0.70, blue: 0.82, alpha: 1.00)
        static let yellow: UIColor = .systemYellow
        static let lightGray: UIColor = .lightGray
        static let gray6: UIColor  = .systemGray6
        static let white: UIColor = .white
        static let red: UIColor = .systemRed
        static let black: UIColor = .black
    }
    
    enum Images {
        static let plusImage = UIImage(systemName: "plus")
        static let bookmarkInactive = UIImage(systemName: "bookmark")
        static let bookmarkActive = UIImage(systemName: "bookmark.fill")
        static let heartInactive = UIImage(systemName: "heart")
        static let heartActive = UIImage(systemName: "heart.fill")
        static let more = UIImage(systemName: "ellipsis")
        static let comment = UIImage(systemName: "bubble.right")
        static let camera = UIImage(systemName: "photo.badge.plus")
        static let addBook = UIImage(systemName: "text.book.closed.fill")
        static let deletePhoto = UIImage(systemName: "minus.circle.fill")
        static let check = UIImage(systemName: "checkmark")
    }
    
    enum Fonts {
        static let regular13 = UIFont.systemFont(ofSize: 13)
        static let regular14 = UIFont.systemFont(ofSize: 14)
        static let regular15 = UIFont.systemFont(ofSize: 15)
        static let regular16 = UIFont.systemFont(ofSize: 16)
        static let regular18 = UIFont.systemFont(ofSize: 18)
        static let bold14 = UIFont.systemFont(ofSize: 14, weight: .bold)
        static let bold15 = UIFont.systemFont(ofSize: 15, weight: .bold)
        static let bold16 = UIFont.systemFont(ofSize: 16, weight: .bold)
        static let bold18 = UIFont.systemFont(ofSize: 18, weight: .bold)
    }
    
    enum Radius {
        static let book: CGFloat = 4
        static let bgView: CGFloat = 8
        static let thumbnail: CGFloat = 10
        static let normal: CGFloat = 12
    }
    
    enum TransitionType {
        case push
        case present
    }
    
    enum Texts {
        static let zero = "0"
        static let max = "99+"
    }
    
    enum Tabman {
        static let height = 44 
    }
}
