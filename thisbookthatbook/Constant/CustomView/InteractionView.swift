//
//  InteractionView.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/19/24.
//

import UIKit
import SnapKit

final class InteractionView: BaseView {
    private let border = UIView()
    private let commentImageView = UIImageView()
    private let commentLabel = UILabel()
    private let likeCntLabel = UILabel()
    private let likeImageView = UIImageView()
    private let likeButton = UIButton()
    private let bookmarkImageView = UIImageView()
    
    override func setupHierarchy() {
        addSubview(border)
        addSubview(commentImageView)
        addSubview(commentLabel)
        addSubview(likeImageView)
        addSubview(likeButton)
        addSubview(likeCntLabel)
        addSubview(bookmarkImageView)
    }
    
    override func setupConstraints() {
        border.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.top.equalTo(safeAreaLayoutGuide)
        }
        
        commentImageView.snp.makeConstraints { make in
            make.centerY.equalTo(safeAreaLayoutGuide)
            make.trailing.equalTo(commentLabel.snp.leading).offset(-6)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.centerY.equalTo(safeAreaLayoutGuide)
            make.trailing.equalTo(likeImageView.snp.leading).offset(-16)
        }
        
        likeImageView.snp.makeConstraints { make in
            make.centerY.equalTo(safeAreaLayoutGuide)
            make.trailing.equalTo(likeCntLabel.snp.leading).offset(-6)
        }
        
        likeButton.snp.makeConstraints { make in
            make.size.equalTo(snp.height)
            make.center.equalTo(likeImageView.snp.center)
        }
        
        likeCntLabel.snp.makeConstraints { make in
            make.trailing.equalTo(bookmarkImageView.snp.leading).inset(-16)
            make.centerY.equalTo(likeImageView.snp.centerY)
        }
        
        bookmarkImageView.snp.makeConstraints { make in
            make.trailing.equalTo(safeAreaLayoutGuide).inset(16)
            make.centerY.equalTo(likeImageView.snp.centerY)
        }
    }
    
    override func setupUI() {
        border.backgroundColor = Resource.Colors.gray6
        commentImageView.image = Resource.Images.comment
        likeImageView.image = Resource.Images.heartInactive
        bookmarkImageView.image = Resource.Images.bookmarkInactive
        
        [likeCntLabel, commentLabel].forEach { label in
            label.font = Resource.Fonts.regular13
            label.text = "0"
        }
        [commentImageView, likeImageView, bookmarkImageView].forEach { imageView in
            imageView.tintColor = Resource.Colors.lightGray
        }
    }
    
    func configureView(_ data: Post) {
        let likeCount = data.likes.count > 99 ? "99+" : "\(data.likes.count)"
        likeCntLabel.text = likeCount
        let commentCount = data.comments.count > 99 ? "99+" : "\(data.comments.count)"
        commentLabel.text = commentCount
    }
}
