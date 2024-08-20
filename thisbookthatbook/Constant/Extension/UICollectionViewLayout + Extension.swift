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
    
    static func PhotoCollectionViewLayout() -> UICollectionViewLayout {
        let inset: CGFloat = 16
        let size = 100
        let spacing: CGFloat = 0
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.scrollDirection = .horizontal
        layout.sectionInset = .init(top: 0, left: inset, bottom: 0, right: inset)
        layout.itemSize = CGSize(width: size, height: size)
        return layout
    }
}
