//
//  PayView.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/28/24.
//

import UIKit
import SnapKit

final class PayView: BaseView {
    private lazy var orderStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.addArrangedSubview(priceLabel)
        stackView.addArrangedSubview(payButton)
        return stackView
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = Resource.Fonts.bold14
        label.textAlignment = .center
        return label
    }()
    
    let payButton = RoundedButton(type: .pay, font: Resource.Fonts.regular14)
    
    override func setupHierarchy() {
        addSubview(orderStackView)
    }
    
    override func setupConstraints() {
        orderStackView.snp.makeConstraints { make in
            make.center.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func setupUI() {
        backgroundColor = Resource.Colors.white.withAlphaComponent(0.7)
        payButton.isEnabled = true
    }
    
    func configureView(_ data: Int?) {
        guard let data else { return }
        priceLabel.text = "\(data)P"
    }
}
