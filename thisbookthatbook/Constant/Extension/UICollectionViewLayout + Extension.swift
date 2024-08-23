//
//  UICollectionViewLayout + Extension.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/19/24.
//

import UIKit

extension UICollectionViewLayout {
    static let inset: CGFloat = 16
    
    // 추천 책 목록 레이아웃
    static func bookCollectionViewLayout() -> UICollectionViewLayout {
        let spacig: CGFloat = 10
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.interGroupSpacing = spacig
        section.contentInsets = .init(top: 0, leading: inset, bottom: 0, trailing: inset)
      
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    // 피드 레이아웃
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
    
    // 사진 레이아웃
    static func PhotoCollectionViewLayout() -> UICollectionViewLayout {
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
    
    // 포스트 상세보기 사진 레이아웃
    static func DetailPhotoCollectionView() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
      
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    // 해시태그 레이아웃
    static func hashTagCollectionView() -> UICollectionViewLayout {
        let spacing: CGFloat = 6
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(1), heightDimension: .estimated(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: inset, bottom: 0, trailing: inset)
        section.interGroupSpacing = spacing
      
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
