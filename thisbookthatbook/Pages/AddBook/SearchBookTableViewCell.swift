//
//  SearchBookTableViewCell.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/21/24.
//

import UIKit
import SnapKit
import Kingfisher

final class SearchBookTableViewCell: BaseTableViewCell {
    private let bookImageView = UIImageView()
    private let contentStackView = UIStackView()
    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let publisherLabel = UILabel()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = Resource.Colors.white
    }
    
    override func setupHierarchy() {
        contentView.addSubview(bookImageView)
        contentView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(authorLabel)
        contentStackView.addArrangedSubview(publisherLabel)
    }
    
    override func setupConstraints() {
        bookImageView.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
            make.width.equalTo(snp.width).multipliedBy(0.18)
            make.height.equalTo(snp.height).multipliedBy(0.7)
            make.centerY.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints { make in
            make.leading.equalTo(bookImageView.snp.trailing).offset(12)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(16)
            make.centerY.equalTo(bookImageView)
        }
    }
    
    override func configureLayout() {
        contentStackView.axis = .vertical
        contentStackView.spacing = 4
        bookImageView.backgroundColor = .blue
        bookImageView.clipsToBounds = true
        bookImageView.layer.cornerRadius = Resource.Radius.book
        titleLabel.font = Resource.Fonts.regular16
        titleLabel.numberOfLines = 2
        [authorLabel, publisherLabel].forEach { label in
            label.font = Resource.Fonts.regular14
            label.textColor = Resource.Colors.lightGray
        }
    }
    
    func configureCell(_ data: Book, selectedBooks: [String]) {
        guard let url = URL(string: data.image) else { return }
        bookImageView.kf.setImage(with: url)
        titleLabel.text = data.title
        authorLabel.text = data.author
        publisherLabel.text = data.publisher
        let isContains = selectedBooks.contains(data.isbn)
        backgroundColor = isContains ? Resource.Colors.black.withAlphaComponent(0.05) : Resource.Colors.white
    }
}
