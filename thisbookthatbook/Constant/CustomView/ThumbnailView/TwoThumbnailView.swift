//
//  TwoThumbnailView.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/19/24.
//

import UIKit
import SnapKit
import Kingfisher

final class TwoThumbnailView: BaseView {
    private let thumbnailImageView1 = UIImageView()
    private let thumbnailImageView2 = UIImageView()
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(thumbnailImageView1)
        stackView.addArrangedSubview(thumbnailImageView2)
        return stackView
    }()
    
    override func setupHierarchy() {
        addSubview(horizontalStackView)
    }
    
    override func setupConstraints() {
        horizontalStackView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView(_ paths: [String]) {
        let imageViews = [thumbnailImageView1, thumbnailImageView2]
        ImageFetcher.shared.getImagesFromServer(paths) { data in
            imageViews[data.idx].kf.setImage(with: data.url, options: [.requestModifier(data.modifier)])
        }
    }
}
