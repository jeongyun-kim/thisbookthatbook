//
//  ThreeThumbnailView.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/18/24.
//

import UIKit
import SnapKit
import Kingfisher

final class ThreeThumbnailView: BaseView {
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(thumbnailImageView1)
        stackView.addArrangedSubview(verticalStackView)
        return stackView
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(thumbnailImageView2)
        stackView.addArrangedSubview(thumbnailImageView3)
        return stackView
    }()
    
    private let thumbnailImageView1 = UIImageView()
    private let thumbnailImageView2 = UIImageView()
    private let thumbnailImageView3 = UIImageView()
    
    override func setupHierarchy() {
        addSubview(horizontalStackView)
    }
    
    override func setupConstraints() {
        horizontalStackView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView(_ paths: [String]) {
        let imageViews = [thumbnailImageView1, thumbnailImageView2, thumbnailImageView3]
        ImageFetcher.shared.getImagesFromServer(paths) { data in
            guard let idx = data.idx else { return }
            imageViews[idx].kf.setImage(with: data.url, options: [.requestModifier(data.modifier)])
        }
    }
}
