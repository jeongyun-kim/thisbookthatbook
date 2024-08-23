//
//  UserContentView.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/19/24.
//

import UIKit
import SnapKit

final class UserContentView: BaseView {
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = Resource.Fonts.regular15
        return label
    }()
    
    private let userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "user")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
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
            make.size.equalTo(40)
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
}
