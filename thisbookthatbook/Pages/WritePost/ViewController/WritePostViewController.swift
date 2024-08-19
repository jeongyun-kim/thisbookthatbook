//
//  WritePostViewController.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/19/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class WritePostViewController: BaseViewController {
    private let vm = WritePostViewModel()
    private let disposeBag = DisposeBag()
    private let main = WritePostView()
    
    enum ViewType {
        case add
        case edit
    }
    let viewType: ViewType = .add
    
    override func loadView() {
        self.view = main
    }
    
    override func setupUI() {
        super.setupUI()
        navigationItem.largeTitleDisplayMode = .never
        let title = viewType == .add ? "navigation_title_add" : "navigation_title_edit"
        navigationItem.title = title.localized
    }
}
