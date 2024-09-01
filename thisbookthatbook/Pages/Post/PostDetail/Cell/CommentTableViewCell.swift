//
//  CommentTableViewCell.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/23/24.
//

import UIKit
import Kingfisher
import SnapKit

final class CommentTableViewCell: BaseTableViewCell {
    private let userProfileImageView = UserProfileImageView(size: .comment)
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = Resource.Fonts.regular13
        return label
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.font = Resource.Fonts.regular14
        label.numberOfLines = 0
        return label
    }()
    
    private let createdDateLabel: UILabel = {
        let label = UILabel()
        label.font = Resource.Fonts.regular13
        label.textColor = Resource.Colors.lightGray
        return label
    }()
    
    override func setupHierarchy() {
        contentView.addSubview(userProfileImageView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(commentLabel)
        contentView.addSubview(createdDateLabel)
    }
    
    override func setupConstraints() {
        userProfileImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(8)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(16)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(userProfileImageView.snp.top)
            make.leading.equalTo(userProfileImageView.snp.trailing).offset(12)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(4)
            make.leading.equalTo(userNameLabel.snp.leading)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(16)
        }
        
        createdDateLabel.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(commentLabel.snp.bottom)
            make.bottom.lessThanOrEqualTo(contentView.safeAreaLayoutGuide).inset(8)
        }
    }
    
    func configureCell(_ data: Comment) {
        configureProfile(data.creator.profileImage)
        userNameLabel.text = data.creator.nick
        commentLabel.text = data.content
        createdDateLabel.text = data.date
    }
    
    private func configureProfile(_ path: String?) {
        guard let path, !path.isEmpty else { return }
        ImageFetcher.shared.getAnImageFromServer(path) { [weak self] imageData in
            self?.userProfileImageView.kf.setImage(with: imageData.url, options: [.requestModifier(imageData.modifier)])
        }
    }
}
