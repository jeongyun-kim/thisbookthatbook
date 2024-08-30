//
//  UserContentView.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/19/24.
//

import UIKit
import Kingfisher
import SnapKit

final class UserContentView: BaseView {
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
    
    override func setupHierarchy() {
        addSubview(userProfileImageView)
        addSubview(userNameLabel)
        addSubview(moreImageView)
        addSubview(moreButton)
    }
    
    override func setupConstraints() {
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
    }
    
    func hideMoreButton(_ id: String) {
        let isMyPost = id == UserDefaultsManager.shared.id
        moreButton.isHidden = !isMyPost
        moreImageView.isHidden = !isMyPost
    }
    
    func configureView(_ data: User) {
        userNameLabel.text = data.nick
        guard let path = data.profileImage else { return }
        ImageFetcher.shared.getAnImageFromServer(path) { [weak self] imageData in
            self?.userProfileImageView.kf.setImage(with: imageData.url, options: [.requestModifier(imageData.modifier)])
        }
    }
}
