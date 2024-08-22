//
//  PostViewController.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/23/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PostViewController: BaseViewController {
    init(vm: PostViewModel, postId: String) {
        super.init(nibName: nil, bundle: nil)
        self.vm = vm
        self.vm.postId.accept(postId)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var vm: PostViewModel!
    override func setupUI() {
        super.setupUI()
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "포스트 상세보기"
    }
    
    override func bind() {
        
    }
}
