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
        static let lightYellow = UIColor(red: 1.00, green: 0.96, blue: 0.80, alpha: 1.00)
        static let lightGray: UIColor = .lightGray
        static let gray6: UIColor  = .systemGray6
        static let white: UIColor = .white
    }
    
    enum Images {
        static let plusImage = UIImage(systemName: "plus")
        static let bookmarkInactive = UIImage(systemName: "bookmark")
        static let bookmarkActive = UIImage(systemName: "bookmark.fill")
        static let heartInactive = UIImage(systemName: "heart")
        static let heartActive = UIImage(systemName: "heart.fill")
    }
    
    enum Fonts {
        static let regular13 = UIFont.systemFont(ofSize: 13)
        static let regular14 = UIFont.systemFont(ofSize: 14)
        static let regular15 = UIFont.systemFont(ofSize: 15)
        static let bold14 = UIFont.systemFont(ofSize: 14, weight: .bold)
        static let bold15 = UIFont.systemFont(ofSize: 15, weight: .bold)
    }
}
