//
//  BookInfoView.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/25/24.
//

import UIKit
import SnapKit

final class BookInfoView: UIView {
    enum BookInfo: String {
        case isbn = "label_book_isbn"
        case author = "label_book_author"
        case publisher = "label_book_publisher"
    }
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.addArrangedSubview(infoTextLabel)
        stackView.addArrangedSubview(infoContentLabel)
        return stackView
    }()
    
    private let infoTextLabel: UILabel = {
        let label = UILabel()
        label.font = Resource.Fonts.regular13
        label.textColor = Resource.Colors.lightGray
        label.textAlignment = .center
        return label
    }()
    
    let infoContentLabel: UILabel = {
        let label = UILabel()
        label.font = Resource.Fonts.regular14
        label.textAlignment = .center
        return label
    }()
    
    init(info: BookInfo) {
        super.init(frame: .zero)
        infoTextLabel.text = info.rawValue.localized
        
        addSubview(infoStackView)
        
        infoStackView.snp.makeConstraints { make in
            make.center.equalTo(safeAreaLayoutGuide)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
