//
//  FeedView.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/17/24.
//

import UIKit

final class FeedView: BaseView {
    let segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl()
        // title 설정
        segment.insertSegment(withTitle: "segment_give_recommend".localized, at: 0, animated: true)
        segment.insertSegment(withTitle: "segment_recieve_recommend".localized, at: 1, animated: true)
        // 선택되어있는 세그먼트는 항상 0번
        segment.selectedSegmentIndex = 0
        // 선택되지 않았을 때의 설정
        segment.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: Resource.Colors.lightGray,
            NSAttributedString.Key.font: Resource.Fonts.regular15
        ], for: .normal)
        // 선택했을 때의 설정
        segment.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: Resource.Colors.black,
            NSAttributedString.Key.font: Resource.Fonts.bold15
        ], for: .selected)
        // 선택했을 때 틴트컬러 없애기
        segment.selectedSegmentTintColor = .clear
        // 배경이랑 구분선 없애기
        segment.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        segment.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        return segment
    }()
    
   lazy var collectionView: UICollectionView = {
       let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .FeedCollectionViewLayout())
       collectionView.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.identifier)
        return collectionView
    }()
    
    override func setupHierarchy() {
        addSubview(segmentControl)
        addSubview(collectionView)
    }
    
    override func setupConstraints() {
        segmentControl.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func setupUI() {
        collectionView.backgroundColor = Resource.Colors.gray6
    }
}
