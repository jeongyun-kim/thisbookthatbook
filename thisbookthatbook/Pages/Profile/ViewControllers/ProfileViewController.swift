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
    
    private let child = ProfileTabManViewController()
    
    private let profileImageView = UserProfileImageView(size: .profileView)
    
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
    
    private lazy var customNavigationView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 56))
        view.addSubview(nicknameLabel)
        return view
    }()
    
    private let nicknameLabel = UILabel()
    
    private let editButton: UIButton = {
        let button = UIButton()
        button.tintColor = Resource.Colors.lightGray
        button.setImage(UIImage(systemName: "square.and.pencil.circle.fill"), for: .normal)
        return button
    }()

    override func setupHierarchy() {
        view.addSubview(profileImageView)
        view.addSubview(editButton)
        view.addSubview(userInfoHorizontalStackView)
        view.addSubview(border)
        view.addSubview(child.view)
    }
    
    override func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        userInfoHorizontalStackView.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView.snp.centerY)
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(50)
        }
        
        border.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(profileImageView.snp.bottom).offset(16)
        }
        
        child.view.snp.makeConstraints { make in
            make.top.equalTo(border.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(customNavigationView.snp.leading).offset(12)
            make.centerY.equalTo(customNavigationView.snp.centerY)
        }
        
        editButton.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.top.equalTo(profileImageView.snp.centerY).offset(-6)
            make.leading.equalTo(profileImageView.snp.trailing).offset(-32)
        }
    }
    
    override func setupUI() {
        super.setupUI()
        addChild(child)
        nicknameLabel.font = Resource.Fonts.bold24
        navigationItem.titleView = customNavigationView
    }
    
    override func bind() {
        let input = ProfileViewModel.Input()
        let output = vm.transform(input)
        
        // 사용자 프로필 정보
        output.profile
            .bind(with: self) { owner, value in
                owner.nicknameLabel.text =  value.nickname
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
        
        editButton.rx.tap
            .withLatestFrom(output.profile)
            .bind(with: self) { owner, value in
                let vc = ProfileEditViewController(vm: ProfileEditViewModel(), profile: value)
                owner.transition(vc)
            }.disposed(by: disposeBag)
    }
    
    private func configureProfileImageView(_ path: String?) {
        guard let path else { return }
        ImageFetcher.shared.getAnImageFromServer(path) { [weak self] imageData in
            self?.profileImageView.kf.setImage(with: imageData.url, options: [.requestModifier(imageData.modifier)])
        }
    }
}
