//
//  BookCollectionViewCell.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/19/24.
//

import UIKit
import SnapKit
import Kingfisher

final class BookCollectionViewCell: BaseCollectionViewCell {
    private let bgView = UIView()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.addArrangedSubview(bookTitleLabel)
        stackView.addArrangedSubview(authorLabel)
        stackView.addArrangedSubview(publisherLabel)
        return stackView
    }()
    
    private let bookImageView = UIImageView()
    private let bookTitleLabel = UILabel()
    private let authorLabel = UILabel()
    private let publisherLabel = UILabel()
    
    override func setupHierarchy() {
        contentView.addSubview(bgView)
        bgView.addSubview(bookImageView)
        bgView.addSubview(verticalStackView)
    }
    
    override func setupConstraints() {
        bgView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(6)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        bookImageView.snp.makeConstraints { make in
            make.height.equalTo(bgView.safeAreaLayoutGuide).multipliedBy(0.8)
            make.width.equalTo(bgView.safeAreaLayoutGuide).multipliedBy(0.18)
            make.centerY.equalTo(bgView)
            make.leading.equalTo(bgView.safeAreaLayoutGuide).offset(32)
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.leading.equalTo(bookImageView.snp.trailing).offset(16)
            make.centerY.equalTo(bookImageView.snp.centerY)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(16)
        }
    }
    
    override func configureLayout() {
        bgView.backgroundColor = Resource.Colors.gray6
        bgView.layer.cornerRadius = Resource.Radius.bgView
        
        bookImageView.backgroundColor = .systemBlue
        bookImageView.layer.cornerRadius = Resource.Radius.book
        
        bookTitleLabel.font = Resource.Fonts.regular14
        bookTitleLabel.numberOfLines = 2
        
        authorLabel.font = Resource.Fonts.regular13
        authorLabel.textColor = Resource.Colors.lightGray
        
        publisherLabel.font = Resource.Fonts.regular13
        publisherLabel.textColor = Resource.Colors.lightGray
    }
    
    func configureCell(_ data: String) {
       // guard let data else { return }
        // 제목 - 작가명 - 출판사명 - 이미지 링크 - 설명 - isbn
        let bookData = data.components(separatedBy: "#")
        bookTitleLabel.text = bookData[0]
        authorLabel.text = bookData[1]
        publisherLabel.text = bookData[2]
        guard let url = URL(string: bookData[3]) else { return }
        bookImageView.kf.setImage(with: url)
    }
}
