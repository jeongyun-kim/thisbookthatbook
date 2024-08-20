//
//  AddPostView.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/21/24.
//

import UIKit
import SnapKit

final class AddPostView: BaseView {
    let contentTextView = UITextView()
    
    lazy var photoCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .PhotoCollectionViewLayout())
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        return collectionView
    }()

    let toolbar = ToolbarView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
    
    override func setupHierarchy() {
        addSubview(photoCollectionView)
        addSubview(contentTextView)
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
    }
    
    override func setupUI() {
        contentTextView.text = "placeholder_write_post".localized
        contentTextView.font = Resource.Fonts.regular15
        contentTextView.textColor = Resource.Colors.lightGray
        contentTextView.autocorrectionType = .no
        contentTextView.spellCheckingType = .no
        contentTextView.inputAccessoryView = toolbar
    }
    
    func configureCollectionViewHeight(_ value: Bool) {
        let height = value ? 100 : 0
        photoCollectionView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
    }
}
