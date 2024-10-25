//
//  InteractionView.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/19/24.
//

import UIKit
import SnapKit

final class InteractionView: BaseView {
    private let border = CustomBorder()
    private let commentImageView = UIImageView()
    private let commentLabel = UILabel()
    private let likeCntLabel = UILabel()
    let likeImageView = UIImageView()
    let likeButton = UIButton()
    let bookmarkImageView = UIImageView()
    let bookmarkButton = UIButton()
    
    override func setupHierarchy() {
        addSubview(border)
        addSubview(commentImageView)
        addSubview(commentLabel)
        addSubview(likeImageView)
        addSubview(likeButton)
        addSubview(likeCntLabel)
        addSubview(bookmarkImageView)
        addSubview(bookmarkButton)
    }
    
    override func setupConstraints() {
        border.snp.makeConstraints { make in
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
        
        bookmarkButton.snp.makeConstraints { make in
            make.size.equalTo(snp.height)
            make.center.equalTo(bookmarkImageView.snp.center)
        }
    }
    
    override func setupUI() {
        border.backgroundColor = Resource.Colors.gray6
        commentImageView.image = Resource.Images.comment
        likeImageView.image = Resource.Images.heartInactive
        bookmarkImageView.image = Resource.Images.bookmarkInactive
        
        [likeCntLabel, commentLabel].forEach { label in
            label.font = Resource.Fonts.regular13
            label.text = Resource.Texts.zero // "0"
        }
        [commentImageView, likeImageView, bookmarkImageView].forEach { imageView in
            imageView.tintColor = Resource.Colors.lightGray
        }
    }
    
    func configureView(_ data: Post) {
        let maxString = Resource.Texts.max // "99+"
        let likeCount = data.likes.count > 99 ? maxString : "\(data.likes.count)"
        likeCntLabel.text = likeCount
        let commentCount = data.comments.count > 99 ? maxString : "\(data.comments.count)"
        commentLabel.text = commentCount
        isLikePost(data.isLikePost)
        isBookmarkPost(data.isBookmarkPost)
    }
    
    private func isLikePost(_ isLike: Bool) {
        let color = isLike ? Resource.Colors.pink : Resource.Colors.lightGray
        let likeImage = isLike ? Resource.Images.heartActive : Resource.Images.heartInactive
        likeImageView.image = likeImage
        likeImageView.tintColor = color
    }
    
    private func isBookmarkPost(_ isBookmark: Bool) {
        let color = isBookmark ? Resource.Colors.yellow : Resource.Colors.lightGray
        let bookmarkImage = isBookmark ? Resource.Images.bookmarkActive : Resource.Images.bookmarkInactive
        bookmarkImageView.image = bookmarkImage
        bookmarkImageView.tintColor = color
    }
}
