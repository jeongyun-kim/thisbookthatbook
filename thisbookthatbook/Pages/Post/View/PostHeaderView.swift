//
//  PostHeaderView.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/23/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PostHeaderView: UITableViewHeaderFooterView {
    private let disposeBag = DisposeBag()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.addArrangedSubview(photoContentsView)
        stackView.addArrangedSubview(contentBackView)
        stackView.addArrangedSubview(bookCollectionView)
        stackView.addArrangedSubview(hashtagCollectionView)
        stackView.addArrangedSubview(commentView)
        return stackView
    }()
    
    private let photoContentsView = UIView()
    
    lazy var photoCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .DetailPhotoCollectionView())
        collectionView.register(DetailPhotoCollectionViewCell.self, forCellWithReuseIdentifier: DetailPhotoCollectionViewCell.identifier)
        return collectionView
    }()
    
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.direction = .leftToRight
        pageControl.pageIndicatorTintColor = Resource.Colors.gray6
        pageControl.currentPageIndicatorTintColor = Resource.Colors.primaryColor
        return pageControl
    }()
    
    private let contentBackView = UIView()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = Resource.Fonts.regular15
        label.numberOfLines = 0
        return label
    }()
    
    let bookCollectionView = BookCollectionView()
    
    lazy var hashtagCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .hashTagCollectionView())
        collectionView.register(HashtagCollectionViewCell.self, forCellWithReuseIdentifier: HashtagCollectionViewCell.identifier)
        return collectionView
    }()
    
    private let commentView: UIView = {
        let view = UIView()
        view.layer.borderColor = Resource.Colors.gray6.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.font = Resource.Fonts.bold16
        label.text = "label_comment".localized
        return label
    }()
    
    private let commentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = Resource.Colors.black
        imageView.image = Resource.Images.comment
        return imageView
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupHierarchy()
        setupConstraints()
        setupUI()
    }
    
    private func setupHierarchy() {
        contentView.addSubview(verticalStackView)
        contentBackView.addSubview(contentLabel)
        commentView.addSubview(commentLabel)
        commentView.addSubview(commentImageView)
        photoContentsView.addSubview(photoCollectionView)
        photoContentsView.addSubview(pageControl)
    }
    
    private func setupConstraints() {
        verticalStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).priority(999)
        }
        
        photoCollectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(photoContentsView.safeAreaLayoutGuide)
            make.height.equalTo(verticalStackView.snp.width)
        }
        
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(photoCollectionView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(photoContentsView)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentBackView.safeAreaLayoutGuide).inset(16)
            make.verticalEdges.equalTo(contentBackView.safeAreaLayoutGuide)
        }
        
        hashtagCollectionView.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        
        commentView.snp.makeConstraints { make in
            make.bottom.equalTo(verticalStackView.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        commentImageView.snp.makeConstraints { make in
            make.centerY.equalTo(commentView)
            make.leading.equalTo(commentView.snp.leading).offset(16)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.centerY.equalTo(commentView)
            make.leading.equalTo(commentImageView.snp.trailing).offset(8)
        }
    }
    
    private func setupUI() {
        contentView.backgroundColor = Resource.Colors.white
    }
    
    func configureView(_ data: Post) {
        contentLabel.text = data.content
        isContainsPhoto(data.files)
        isContainsBook(data.books)
        isContainsHashtag(data.hashtags)
    }
    
    private func isContainsPhoto(_ files: [String]) {
        guard !files.isEmpty else {
            // 사진이 하나도 없다면 사진 관련 뷰 숨기기
            photoContentsView.isHidden = true
            return
        }
        // 사진이 한 장 이상이라면 사진 컬렉션뷰 그리고
        Observable.just(files)
            .bind(to: photoCollectionView.rx.items(cellIdentifier: DetailPhotoCollectionViewCell.identifier, cellType: DetailPhotoCollectionViewCell.self)) { (row, element, cell) in
                cell.configureCell(element)
            }.disposed(by: disposeBag)
        // pageControl 세팅
        configurePageControl(files)
    }
    
    private func configurePageControl(_ files: [String]) {
        guard files.count > 1 else {
            // 사진이 한 장일 때에는 pageControl 숨기기
            pageControl.isHidden = true
            return
        }
        // 사진이 두 장 이상일 때, pageControl 세팅
        pageControl.numberOfPages = files.count
        // 곧 보여줄 셀의 정보
        photoCollectionView.rx.willDisplayCell
            .bind(with: self) { owner, value in
                let currentPage = value.at.row
                owner.pageControl.currentPage = currentPage
            }.disposed(by: disposeBag)
    }
    
    private func isContainsBook(_ books: [String]) {
        guard !books.isEmpty else {
            // 포함된 책 정보가 없다면 컬렉션뷰 숨기기
            bookCollectionView.isHidden = true
            return
        }
        // 책 정보가 포함되어있다면 컬렉션뷰 그려주기
        Observable.just(books)
            .bind(to: bookCollectionView.rx.items(cellIdentifier: BookCollectionViewCell.identifier, cellType: BookCollectionViewCell.self)) { (row, element, cell) in
                cell.configureCell(element)
            }.disposed(by: disposeBag)
    }
   
    private func isContainsHashtag(_ hashtags: [String]) {
        guard !hashtags.isEmpty else {
            // 해시태그가 없다면 컬렉션뷰 숨기기
            hashtagCollectionView.isHidden = true
            return
        }
        // 해시태그가 하나라도 있다면 컬렉션뷰 그리기
        Observable.just(hashtags)
            .bind(to: hashtagCollectionView.rx.items(cellIdentifier: HashtagCollectionViewCell.identifier, cellType: HashtagCollectionViewCell.self)) { (row, element, cell) in
                cell.configureCell(element)
            }.disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
