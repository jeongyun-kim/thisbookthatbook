//
//  HashtagCollectionViewCell.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/23/24.
//

import UIKit
import SnapKit

final class HashtagCollectionViewCell: BaseCollectionViewCell {
    private let hashtagLabel: UILabel = {
        let label = UILabel()
        label.font = Resource.Fonts.regular14
        label.textColor = Resource.Colors.lightGray
        return label
    }()
    
    override func setupHierarchy() {
        contentView.addSubview(hashtagLabel)
    }
    
    override func setupConstraints() {
        hashtagLabel.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(4)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(6)
        }
    }
    
    override func configureLayout() {
        contentView.layer.cornerRadius = Resource.Radius.normal
        contentView.backgroundColor = Resource.Colors.gray6
    }
    
    func configureCell(_ data: String) {
        hashtagLabel.text = data
    }
}
