//
//  DetailPhotoCollectionViewCell.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/23/24.
//

import UIKit
import SnapKit
import RxSwift
import Kingfisher

final class DetailPhotoCollectionViewCell: BaseCollectionViewCell {
    var disposeBag = DisposeBag()
    private let photoImageView = UIImageView()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func setupHierarchy() {
        contentView.addSubview(photoImageView)
    }
    
    override func setupConstraints() {
        photoImageView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(contentView.snp.width)
        }
    }
    
    func configureCell(_ path: String) {
        ImageFetcher.shared.getAnImageFromServer(path) { [weak self] imageData in
            self?.photoImageView.kf.setImage(with: imageData.url, options: [.requestModifier(imageData.modifier)])
        }
    }
}


