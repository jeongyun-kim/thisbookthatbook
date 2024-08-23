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
    
    private let thumbnailView = ThumbnailView()
    
    let userContentsView = UserContentView()
    
    private let contentLabel = UILabel()
    
    let bookCollectionView = BookCollectionView()
    
    let userContentsButton = UIButton()
    
    let contentsButton = UIButton()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
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
        thumbnailView.setupUI()
    }
    
    override func setupHierarchy() {
        contentView.addSubview(stackView)
        contentView.addSubview(userContentsButton)
        contentView.addSubview(contentsButton)
    }
    
    override func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(8)
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).priority(999)
        }
        
        userContentsView.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        
        thumbnailView.snp.makeConstraints { make in
            make.height.equalTo(stackView.snp.width).multipliedBy(0.8)
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
        
        userContentsButton.snp.makeConstraints { make in
            make.edges.equalTo(userContentsView)
        }
        
        contentsButton.snp.makeConstraints { make in
            make.top.equalTo(thumbnailView.snp.top)
            make.horizontalEdges.bottom.equalTo(contentLabel)
        }
    }
    
    override func configureLayout() {
        backgroundColor = Resource.Colors.white
        contentLabel.font = Resource.Fonts.regular14
        contentLabel.numberOfLines = 4
        thumbnailView.clipsToBounds = true
        thumbnailView.layer.cornerRadius = Resource.Radius.thumbnail
    }
    
    func configureCell(_ data: Post) {
        let isContainsThumbnail = !data.files.isEmpty // 받아온 이미지가 있는지 확인
        thumbnailView.isHidden = !isContainsThumbnail // 받아온 이미지가 있다면 isHidden = false / 아니면 true
        thumbnailView.configureView(data.files) // 썸네일 이미지 구성
        userContentsView.userNameLabel.text = data.creator.nick // 사용자 닉네임
        contentLabel.text = data.content // 본문
        interactionView.configureView(data) // 좋아요 개수 / 좋아요 상태 / 북마크 상태 / 댓글 개수 반영
        isContainsBook(data.books) // 책정보가 있는지에 따라 책 정보 컬렉션뷰 숨기거나 보여주기
        userContentsView.hideMoreButton(data.creator.user_id) // 게시글의 글쓴이가 로그인한 나라면 더보기 버튼 냅두기
    }
    
    func isContainsBook(_ books: [String]) {
        guard !books.isEmpty else {
            bookCollectionView.isHidden = true
            return
        }
        bookCollectionView.isHidden = false
    }
}
