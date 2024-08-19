//
//  FeedCollectionViewCell.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/18/24.
//

import UIKit
import SnapKit
import RxSwift

class FeedCollectionViewCell: BaseCollectionViewCell {
    var disposeBag = DisposeBag()
    let thumbnailView = ThumbnailView()
    let userContentsView = UserContentView()
    let contentLabel = UILabel()
    lazy var bookCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .bookCollectionViewLayout())
        collectionView.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: BookCollectionViewCell.identifier)
        return collectionView
    }()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.addArrangedSubview(userContentsView)
        stackView.addArrangedSubview(thumbnailView)
        stackView.addArrangedSubview(contentLabel)
        stackView.addArrangedSubview(bookCollectionView)
        stackView.addArrangedSubview(interactionView)
        return stackView
    }()
    let interactionView = InteractionView()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        bookCollectionView.isHidden = true
        thumbnailView.isHidden = true
    }
    
    override func setupHierarchy() {
        contentView.addSubview(stackView)
    }
    
    override func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).priority(999)
        }
        
        userContentsView.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        
        thumbnailView.snp.makeConstraints { make in
            make.height.equalTo(160)
        }
        
        bookCollectionView.snp.makeConstraints { make in
            make.height.equalTo(120)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(stackView)
        }
        
        interactionView.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
    }
    
    override func configureLayout() {
        backgroundColor = Resource.Colors.white
        contentLabel.font = Resource.Fonts.regular14
        contentLabel.numberOfLines = 4
    }
    
    func configureCell(_ data: Post) {
        let isContainsThumbnail = !data.files.isEmpty
        thumbnailView.isHidden = !isContainsThumbnail
        thumbnailView.configureView(data.files)
        userContentsView.userNameLabel.text = data.creator.nick
        contentLabel.text = data.content
        interactionView.configureView(data)
        isContainsBook(data.content1)
    }
    
    func isContainsBook(_ data: String?) {
        guard let data, data.count > 0 else { 
            bookCollectionView.isHidden = true
            return }
        bookCollectionView.isHidden = false
    }
}
