//
//  TwoThumbnailView.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/19/24.
//

import UIKit
import SnapKit

final class TwoThumbnailView: BaseView {
    private let thumbnailImageView1 = UIImageView()
    private let thumbnailImageView2 = UIImageView()
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
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
    
    override func configureView(_ thumbs: [String]) {
        thumbnailImageView1.image = UIImage(systemName: "star")
        thumbnailImageView2.image = UIImage(systemName: "heart")
    }
}
