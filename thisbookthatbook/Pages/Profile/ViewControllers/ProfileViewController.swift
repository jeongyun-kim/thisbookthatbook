//
//  ProfileViewController.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/13/24.
//

import UIKit
import SnapKit

final class ProfileViewController: BaseViewController {
    private let profileImageView = UserProfileImageView(size: .profileView)
    private let child = TabManViewController()
    
    private lazy var userContentsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.addArrangedSubview(userNameLabel)
        stackView.addArrangedSubview(userEmailLabel)
        return stackView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = Resource.Fonts.bold18
        label.text = ":>"
        return label
    }()
    
    private let userEmailLabel: UILabel = {
        let label = UILabel()
        label.font = Resource.Fonts.regular13
        label.textColor = Resource.Colors.lightGray
        label.text = "unknown@naver.com"
        return label
    }()
    
    private lazy var userInfoHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.addArrangedSubview(postView)
        stackView.addArrangedSubview(followerView)
        stackView.addArrangedSubview(followingView)
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let postView = UserInfoView(info: .post)
    let followerView = UserInfoView(info: .followers)
    let followingView = UserInfoView(info: .followings)
    
    let border = CustomBorder()

    override func setupHierarchy() {
        view.addSubview(profileImageView)
        view.addSubview(userContentsStackView)
        view.addSubview(userInfoHorizontalStackView)
        view.addSubview(border)
        view.addSubview(child.view)
    }
    
    override func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        userContentsStackView.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView.snp.centerY)
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        userInfoHorizontalStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.top.equalTo(profileImageView.snp.bottom).offset(16)
            make.height.equalTo(50)
        }
        
        border.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(userInfoHorizontalStackView.snp.bottom).offset(12)
        }
        
        child.view.snp.makeConstraints { make in
            make.top.equalTo(border.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func setupUI() {
        super.setupUI()
        addChild(child)
    }
}
