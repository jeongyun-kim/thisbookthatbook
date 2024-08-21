//
//  BookCollectionView.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/21/24.
//

import UIKit
import SnapKit

final class BookCollectionView: UICollectionView {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: .zero, collectionViewLayout: .bookCollectionViewLayout())
        
        register(BookCollectionViewCell.self, forCellWithReuseIdentifier: BookCollectionViewCell.identifier)
        
        snp.makeConstraints { make in
            make.height.equalTo(120)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
