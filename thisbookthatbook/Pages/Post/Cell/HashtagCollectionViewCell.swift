//
//  HashtagCollectionViewCell.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/23/24.
//

import UIKit
import SnapKit

final class HashtagCollectionViewCell: BaseCollectionViewCell {
    private let hashtagButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = Resource.Colors.gray6
        config.baseForegroundColor = Resource.Colors.lightGray
        config.cornerStyle = .capsule
        button.configuration = config
        return button
    }()

    override func setupHierarchy() {
        contentView.addSubview(hashtagButton)
    }
    
    override func setupConstraints() {
        hashtagButton.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    func configureCell(_ data: String) {
        let attributedTitle = NSAttributedString(string: data, attributes: [.font: Resource.Fonts.regular13])
        hashtagButton.setAttributedTitle(attributedTitle, for: .normal)
    }
}
