//
//  PhotoCollectionViewCell.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/20/24.
//

import UIKit
import SnapKit
import RxSwift

final class PhotoCollectionViewCell: BaseCollectionViewCell {
    var disposeBag = DisposeBag()
    private let photoImageView = UIImageView()
    private let deleteImageView = UIImageView()
    let deleteButton = UIButton()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func setupHierarchy() {
        contentView.addSubview(photoImageView)
        contentView.addSubview(deleteImageView)
        contentView.addSubview(deleteButton)
    }
    
    override func setupConstraints() {
        photoImageView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide).inset(4)
        }
        
        deleteImageView.snp.makeConstraints { make in
            make.trailing.top.equalTo(safeAreaLayoutGuide).inset(6)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.trailing.top.equalTo(photoImageView)
        }
    }
    
    override func configureLayout() {
        photoImageView.clipsToBounds = true
        photoImageView.layer.cornerRadius = Resource.Radius.normal
        photoImageView.layer.borderWidth = 1
        photoImageView.layer.borderColor = Resource.Colors.gray6.cgColor
        deleteImageView.image = Resource.Images.deletePhoto
        deleteImageView.tintColor = Resource.Colors.red
    }
    
    func configureCell(_ data: UIImage?) {
        photoImageView.image = data
    }
}
