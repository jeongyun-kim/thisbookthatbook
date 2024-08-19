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
    
    private let moreButton = UIButton()
    
    override func setupHierarchy() {
        addSubview(userProfileImageView)
        addSubview(userNameLabel)
        addSubview(moreImageView)
        addSubview(moreButton)
    }
    
    override func setupConstraints() {
        userProfileImageView.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.leading.equalTo(safeAreaLayoutGuide)
            make.centerY.equalTo(safeAreaLayoutGuide)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(userProfileImageView)
            make.leading.equalTo(userProfileImageView.snp.trailing).offset(12)
        }
        
        moreImageView.snp.makeConstraints { make in
            make.centerY.equalTo(userNameLabel)
            make.trailing.equalTo(safeAreaLayoutGuide)
        }
        
        moreButton.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.center.equalTo(moreImageView.snp.center)
        }
    }
}
