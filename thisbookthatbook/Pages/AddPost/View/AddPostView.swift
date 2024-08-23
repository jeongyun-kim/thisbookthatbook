//
//  AddPostView.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/21/24.
//

import UIKit
import SnapKit
import PhotosUI

final class AddPostView: BaseView {
    let toolbar = TextViewToolbarView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
    
    lazy var contentTextView: UITextView = {
        let textView = UITextView()
        textView.text = "placeholder_write_post".localized
        textView.font = Resource.Fonts.regular15
        textView.textColor = Resource.Colors.lightGray
        textView.autocorrectionType = .no
        textView.spellCheckingType = .no
        textView.inputAccessoryView = toolbar
        return textView
    }()
    
    lazy var photoCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .PhotoCollectionViewLayout())
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        return collectionView
    }()
    
    let picker: PHPickerViewController = {
        var config = PHPickerConfiguration()
        config.selectionLimit = 3
        config.filter = .images
        let vc = PHPickerViewController(configuration: config)
        return vc
    }()
    
    let bookCollectionView = BookCollectionView()
    
    override func setupHierarchy() {
        addSubview(photoCollectionView)
        addSubview(contentTextView)
        addSubview(bookCollectionView)
    }
    
    override func setupConstraints() {
        photoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(0)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(photoCollectionView.snp.bottom)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
            make.height.equalTo(300)
        }
        
        bookCollectionView.snp.makeConstraints { make in
            make.top.equalTo(contentTextView.snp.bottom)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
        }
    }
    
    func configureCollectionViewHeight(_ value: Bool) {
        let height = value ? 100 : 0
        photoCollectionView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
    }
}
