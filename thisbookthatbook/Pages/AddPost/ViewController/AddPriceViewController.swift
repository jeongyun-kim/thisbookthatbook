//
//  AddPriceViewController.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/29/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class AddPriceViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    
    private let descLabel = UILabel()
    private let priceTextField = CustomTextField(.price)
    private let addButton = NextButton(title: .save)
    
    var sendPrice: ((String?) -> Void)?
    
    override func setupHierarchy() {
        view.addSubview(descLabel)
        view.addSubview(priceTextField)
        view.addSubview(addButton)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        sendPrice?(priceTextField.text)
    }
    
    override func setupConstraints() {
        descLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(36)
        }
        
        priceTextField.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
        
        addButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
    }
    
    override func setupUI() {
        super.setupUI()
        descLabel.text = "label_add_price".localized
        descLabel.font = Resource.Fonts.bold18
        priceTextField.keyboardType = .decimalPad
        view.layer.cornerRadius = Resource.Radius.large
    }
    
    override func bind() {
        addButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }.disposed(by: disposeBag)
    }
}
