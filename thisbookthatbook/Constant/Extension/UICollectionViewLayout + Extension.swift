//
//  UICollectionViewLayout + Extension.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/19/24.
//

import UIKit

extension UICollectionViewLayout {
    static func bookCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.95), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        section.interGroupSpacing = 10
      
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
