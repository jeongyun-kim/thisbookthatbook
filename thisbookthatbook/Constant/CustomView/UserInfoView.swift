//
//  UserInfoView.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/25/24.
//

import UIKit
import SnapKit

final class UserInfoView: UIView {
    enum UserInfo: String {
        case post = "포스트"
        case followers = "팔로워"
        case followings = "팔로잉"
    }
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.addArrangedSubview(infoTextLabel)
        stackView.addArrangedSubview(infoContentLabel)
        return stackView
    }()
    
    private let infoTextLabel: UILabel = {
        let label = UILabel()
        label.font = Resource.Fonts.regular14
        label.textColor = Resource.Colors.lightGray
        label.textAlignment = .center
        return label
    }()
    
    private let infoContentLabel: UILabel = {
        let label = UILabel()
        label.font = Resource.Fonts.bold15
        label.textAlignment = .center
        label.text = "999"
        return label
    }()
    
    init(info: UserInfo) {
        super.init(frame: .zero)
        infoTextLabel.text = info.rawValue.localized
        
        addSubview(infoStackView)
        
        infoStackView.snp.makeConstraints { make in
            make.center.equalTo(safeAreaLayoutGuide)
        }
    }
    
    func configureView(_ data: Int) {
        infoContentLabel.text = "\(data)"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
