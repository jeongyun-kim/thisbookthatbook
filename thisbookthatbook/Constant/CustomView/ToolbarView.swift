//
//  ToolbarView.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/20/24.
//

import UIKit
import SnapKit

final class ToolbarView: BaseView {
    private let border = CustomBorder()
    private lazy var photoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.addArrangedSubview(photoImageView)
        stackView.addArrangedSubview(photoLabel)
        return stackView
    }()
    private let photoImageView = UIImageView()
    private let photoLabel = UILabel()
    private lazy var bookStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.addArrangedSubview(bookImageView)
        stackView.addArrangedSubview(bookLabel)
        return stackView
    }()
    private let bookImageView = UIImageView()
    private let photoButton = UIButton()
    private let bookButton = UIButton()
    private let bookLabel = UILabel()
    
    override func setupHierarchy() {
        addSubview(border)
        addSubview(photoStackView)
        addSubview(photoButton)
        addSubview(bookStackView)
        addSubview(bookButton)
    }
    
    override func setupConstraints() {
        border.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        photoStackView.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.centerY.equalTo(safeAreaLayoutGuide)
        }
        
        photoButton.snp.makeConstraints { make in
            make.width.equalTo(photoStackView.snp.width)
            make.center.equalTo(photoStackView.snp.center)
        }
        
        bookStackView.snp.makeConstraints { make in
            make.leading.equalTo(photoStackView.snp.trailing).offset(8)
            make.centerY.equalTo(safeAreaLayoutGuide)
        }
        
        bookButton.snp.makeConstraints { make in
            make.width.equalTo(bookStackView.snp.width)
            make.center.equalTo(bookStackView.snp.center)
        }
    }
    
    override func setupUI() {
        photoImageView.image = Resource.Images.camera
        photoLabel.text = "label_add_photo".localized
        bookImageView.image = Resource.Images.addBook
        bookLabel.text = "label_add_book".localized
        
        [bookImageView, photoImageView].forEach { imageView in
            imageView.tintColor = Resource.Colors.lightGray
        }
        [bookLabel, photoLabel].forEach { label in
            label.font = Resource.Fonts.regular14
            label.textColor = Resource.Colors.lightGray
        }
    }
}
