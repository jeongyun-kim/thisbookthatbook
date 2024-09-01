//
//  BookViewController.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/24/24.
//

import UIKit

final class BookViewController: BaseViewController {
    init(data: String) {
        super.init(nibName: nil, bundle: nil)
        self.data = data
    }
    
    private let main = BookView()
    var data: String = ""
    
    override func loadView() {
        self.view = main
    }
    
    override func setupUI() {
        main.configureView(data)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
