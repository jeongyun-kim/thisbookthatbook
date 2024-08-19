//
//  UICollectionViewLayout + Extension.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/19/24.
//

import UIKit

extension UICollectionViewLayout {
    static func bookCollectionViewLayout() -> UICollectionViewLayout {
        let spacig: CGFloat = 10
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.interGroupSpacing = spacig
      
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    static func FeedCollectionViewLayout() -> UICollectionViewLayout {
        let spacing: CGFloat = 20
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
      
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
}
