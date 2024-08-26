//
//  FeedView.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/17/24.
//

import UIKit

final class FeedView: BaseView {
   lazy var collectionView: UICollectionView = {
       let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .FeedCollectionViewLayout())
       collectionView.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.identifier)
       collectionView.backgroundColor = Resource.Colors.gray6
        return collectionView
    }()
    
    let addPostButton = PlusButton()
    
    override func setupHierarchy() {
        addSubview(collectionView)
        addSubview(addPostButton)
    }
    
    override func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(Resource.Tabman.height)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        addPostButton.snp.makeConstraints { make in
            make.trailing.equalTo(safeAreaLayoutGuide).inset(24)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(30)
        }
    }
}
