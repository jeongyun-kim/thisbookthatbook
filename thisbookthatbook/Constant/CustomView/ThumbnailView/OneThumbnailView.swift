//
//  OneThumbnailView.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/19/24.
//

import UIKit
import SnapKit
import Kingfisher

final class OneThumbnailView: BaseView {
    private let thumbnailImageView = UIImageView()
    
    override func setupHierarchy() {
        addSubview(thumbnailImageView)
    }
    
    override func setupConstraints() {
        thumbnailImageView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView(_ paths: [String]) {
        ImageFetcher.shared.getImagesFromServer(paths) { [weak self] data in
            self?.thumbnailImageView.kf.setImage(with: data.url, options: [.requestModifier(data.modifier)])
        }
    }
}
