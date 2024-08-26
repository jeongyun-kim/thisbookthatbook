//
//  ProfileViewController.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/13/24.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa
import SnapKit
import Toast

final class ProfileViewController: BaseViewController {
    private let vm = ProfileViewModel()
    private let disposeBag = DisposeBag()
    
    private let child = TabManViewController()
    
    private let profileImageView = UserProfileImageView(size: .profileView)
    
    private lazy var userContentsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.addArrangedSubview(userNameLabel)
        stackView.addArrangedSubview(userEmailLabel)
        return stackView
    }()
    
    private let userNameLabel = UILabel()
    
    private let userEmailLabel = UILabel()
    
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
        userNameLabel.font = Resource.Fonts.bold18
        userEmailLabel.font = Resource.Fonts.regular13
        userEmailLabel.textColor = Resource.Colors.lightGray
    }
    
    override func bind() {
        let input = ProfileViewModel.Input()
        let output = vm.transform(input)
        
        // 사용자 프로필 정보
        output.profile
            .bind(with: self) { owner, value in
                owner.userNameLabel.text = value.nickname
                owner.userEmailLabel.text = value.email
                owner.postView.configureView(value.posts.count)
                owner.followerView.configureView(value.followers.count)
                owner.followingView.configureView(value.following.count)
                owner.configureProfileImageView(value.profileImage)
            }.disposed(by: disposeBag)
        
        // 토큰 만료 시
        output.alert
            .asSignal()
            .emit(with: self) { owner, _ in
                owner.showExpiredTokenAlert()
            }.disposed(by: disposeBag)
        
        // 그 외 에러는 토스트메시지
        output.toastMessage
            .asSignal()
            .emit(with: self) { owner, value in
                owner.showToast(message: value)
            }.disposed(by: disposeBag)
    }
    
    private func configureProfileImageView(_ path: String?) {
        guard let path else { return }
        ImageFetcher.shared.getAnImageFromServer(path) { [weak self] imageData in
            self?.profileImageView.kf.setImage(with: imageData.url, options: [.requestModifier(imageData.modifier)])
        }
    }
}
