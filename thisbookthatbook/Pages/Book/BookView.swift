//
//  BookView.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/24/24.
//

import UIKit
import Kingfisher

final class BookView: BaseView {
    
    private let contentsView: UIView = {
        let view = UIView()
        view.backgroundColor = Resource.Colors.white
        view.layer.cornerRadius = Resource.Radius.normal
        return view
    }()
    
    private let bookImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Resource.Radius.book
        return imageView
    }()
    
    private let bookTitleLabel: UILabel = {
        let label = UILabel()
        label.font = Resource.Fonts.bold16
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.backgroundColor = Resource.Colors.gray6
        stackView.layer.cornerRadius = Resource.Radius.bgView
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(isbnView)
        stackView.addArrangedSubview(authorView)
        stackView.addArrangedSubview(publisherView)
        return stackView
    }()
    
    private let isbnView: BookInfoView = {
        let view = BookInfoView(info: .isbn)
        view.infoContentLabel.font = Resource.Fonts.regular13
        return view
    }()
    
    private let authorView = BookInfoView(info: .author)

    private let publisherView = BookInfoView(info: .publisher)
    
    private let summaryView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Resource.Radius.normal
        view.backgroundColor = Resource.Colors.gray6
        return view
    }()
    
    private let summaryTextLabel: UILabel = {
        let label = UILabel()
        label.font = Resource.Fonts.regular14
        label.textColor = Resource.Colors.lightGray
        label.text = "label_book_desc".localized
        return label
    }()

    private let summaryScrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    private let summaryContentLabel: UILabel = {
        let label = UILabel()
        label.font = Resource.Fonts.regular14
        label.numberOfLines = 0
        return label
    }()
    
    override func setupHierarchy() {
        addSubview(contentsView)
        addSubview(bookImageView)
        contentsView.addSubview(bookTitleLabel)
        contentsView.addSubview(horizontalStackView)
        addSubview(summaryView)
        summaryView.addSubview(summaryTextLabel)
        summaryView.addSubview(summaryScrollView)
        summaryScrollView.addSubview(summaryContentLabel)
    }
    
    override func setupConstraints() {
        bookImageView.snp.makeConstraints { make in
            make.width.equalTo(safeAreaLayoutGuide).multipliedBy(0.3)
            make.height.equalTo(bookImageView.snp.width).multipliedBy(1.3)
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.top.equalTo(safeAreaLayoutGuide)
        }
        
        contentsView.snp.makeConstraints { make in
            make.top.equalTo(bookImageView.snp.centerY).dividedBy(0.8)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        bookTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(bookImageView.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(contentsView.safeAreaLayoutGuide).inset(16)
        }
        
        horizontalStackView.snp.makeConstraints { make in
            make.top.equalTo(bookTitleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
            make.height.equalTo(90)
        }
        
        summaryView.snp.makeConstraints { make in
            make.top.equalTo(horizontalStackView.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
            make.bottom.equalToSuperview()
        }
        
        summaryTextLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(summaryView).offset(12)
        }
        
        summaryScrollView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(summaryView.safeAreaLayoutGuide).inset(12)
            make.top.equalTo(summaryTextLabel.snp.bottom).offset(6)
            make.bottom.equalTo(summaryView.safeAreaLayoutGuide).inset(16)
        }

        summaryContentLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(summaryScrollView.safeAreaLayoutGuide)
            make.verticalEdges.equalTo(summaryScrollView)
        }
    }
    
    func configureView(_ data: String) {
        // 제목 - 작가명 - 출판사명 - 이미지 링크 - 설명 - isbn
        let bookData = data.components(separatedBy: "#")
        bookTitleLabel.text = bookData[0]
        authorView.infoContentLabel.text = bookData[1]
        publisherView.infoContentLabel.text = bookData[2]
        guard let url = URL(string: bookData[3]) else { return }
        bookImageView.kf.setImage(with: url)
        summaryContentLabel.text = bookData[4]
        isbnView.infoContentLabel.text = bookData[5]
    }
}
