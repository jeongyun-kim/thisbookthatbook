//
//  WebViewController.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/30/24.
//

import UIKit
import iamport_ios
import SnapKit
import WebKit

final class WebViewController: BaseViewController {
    lazy var wkWebView: WKWebView = {
        var view = WKWebView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        return button
    }()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Iamport.shared.close()
    }
    
    override func setupHierarchy() {
        view.addSubview(wkWebView)
        view.addSubview(dismissButton)
    }
    
    override func setupConstraints() {
        wkWebView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        dismissButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.size.equalTo(40)
        }
    }
    
    @objc private func dismissVC(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    
}
