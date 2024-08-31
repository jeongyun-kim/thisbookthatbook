//
//  UserContentsView.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/19/24.
//

import UIKit
import Kingfisher
import SnapKit

final class UserContentsView: BaseView {
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = Resource.Fonts.regular15
        return label
    }()
    
    private let userProfileImageView = UserProfileImageView()
    
    private let moreImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Resource.Images.more
        imageView.transform = imageView.transform.rotated(by: .pi/2)
        imageView.tintColor = Resource.Colors.black
        return imageView
    }()
    
    let moreButton = UIButton()
    
    private let followView = UIView()
    
    let followButton = RoundedButton(type: .follow, font: Resource.Fonts.regular13)
    let followingButton = RoundedButton(type: .following, font: Resource.Fonts.regular13)
    let followViewButton = UIButton()
    
    override func setupHierarchy() {
        addSubview(userProfileImageView)
        addSubview(userNameLabel)
        addSubview(moreImageView)
        addSubview(moreButton)
        addSubview(followView)
        addSubview(followViewButton)
        followView.addSubview(followButton)
        followView.addSubview(followingButton)
    }
    
    override func setupConstraints() {
        snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        
        userProfileImageView.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
            make.centerY.equalTo(safeAreaLayoutGuide)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(userProfileImageView)
            make.leading.greaterThanOrEqualTo(userProfileImageView.snp.trailing).offset(12)
        }
        
        moreImageView.snp.makeConstraints { make in
            make.centerY.equalTo(userNameLabel)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        moreButton.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.center.equalTo(moreImageView.snp.center)
        }
        
        followView.snp.makeConstraints { make in
            make.centerY.equalTo(safeAreaLayoutGuide)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        followViewButton.snp.makeConstraints { make in
            make.edges.equalTo(followView)
        }
        
        followButton.snp.makeConstraints { make in
            make.edges.equalTo(followView)
        }
        
        followingButton.snp.makeConstraints { make in
            make.edges.equalTo(followView)
        }
    }
    
    func setButtonsVisible(_ id: String) {
        let isMyPost = id == UserDefaultsManager.shared.id
        moreButton.isHidden = !isMyPost
        moreImageView.isHidden = !isMyPost
        followView.isHidden = isMyPost
        followViewButton.isHidden = isMyPost
    }
    
    func configureFollowStatus(_ id: String) {
        let isFollowing = UserDefaultsManager.shared.followings.contains(id)
        followingButton.isHidden = !isFollowing
        followButton.isHidden = isFollowing
    }
    
    func configureView(_ data: User) {
        configureFollowStatus(data.user_id)
        setButtonsVisible(data.user_id)
        userNameLabel.text = data.nick
        guard let path = data.profileImage else { return }
        ImageFetcher.shared.getAnImageFromServer(path) { [weak self] imageData in
            self?.userProfileImageView.kf.setImage(with: imageData.url, options: [.requestModifier(imageData.modifier)])
        }
    }
    
    func resetView() {
        moreButton.isHidden = true
        moreImageView.isHidden = true
        userProfileImageView.image = Resource.Images.user
        followView.isHidden = true
    }
}
