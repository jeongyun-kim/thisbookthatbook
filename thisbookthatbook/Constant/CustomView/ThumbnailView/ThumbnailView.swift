//
//  ThumbnailView.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/19/24.
//

import UIKit
import SnapKit

final class ThumbnailView: BaseView {
    
    private let oneThumbnailView = OneThumbnailView()
    private let twoThumbnailView = TwoThumbnailView()
    private let threeThumbnailView = ThreeThumbnailView()
    
    override func setupHierarchy() {
        addSubview(oneThumbnailView)
        addSubview(twoThumbnailView)
        addSubview(threeThumbnailView)
    }
    
    override func setupConstraints() {
        oneThumbnailView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        twoThumbnailView.snp.makeConstraints { make in
            make.edges.equalTo(oneThumbnailView)
        }
        
        threeThumbnailView.snp.makeConstraints { make in
            make.edges.equalTo(twoThumbnailView)
        }
    }
    
    override func setupUI() {
        hideAllViews()
    }
    
    func hideAllViews() {
        oneThumbnailView.isHidden = true
        twoThumbnailView.isHidden = true
        threeThumbnailView.isHidden = true
    }
    
    override func configureView(_ thumbs: [String]) {
        guard !thumbs.isEmpty else { return }
        let imageView = [oneThumbnailView, twoThumbnailView, threeThumbnailView]
        let idx = thumbs.count - 1
        imageView[idx].configureView(thumbs)
        imageView[idx].isHidden = false
    }
}

