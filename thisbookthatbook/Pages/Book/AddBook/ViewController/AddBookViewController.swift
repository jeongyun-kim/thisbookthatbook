//
//  AddBookViewController.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/21/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Toast

final class AddBookViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    private let main = AddBookView()
    private let vm = AddBookViewModel()
    var sendBooks: (([Book]) -> Void)?
    override func loadView() {
        self.view = main
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sendBooks?(vm.books)
    }
    
    override func setupUI() {
        super.setupUI()
        navigationItem.title = "naviagation_title_add_book".localized
    }
    
    override func bind() {
        let searchBtnTapped = main.searchBar.rx.searchButtonClicked
        let searchKeyword = main.searchBar.rx.text.orEmpty
        let prefetchRows = main.tableView.rx.prefetchRows
        let selectedBook = main.tableView.rx.modelSelected(Book.self)
        
        let input = AddBookViewModel.Input(searchBtnTapped: searchBtnTapped, searchKeyword: searchKeyword, prefetchRows: prefetchRows, selectedModel: selectedBook)
        let output = vm.transform(input)

        output.searchResults
            .asDriver()
            .drive(main.tableView.rx.items(cellIdentifier: SearchBookTableViewCell.identifier, cellType: SearchBookTableViewCell.self)) { (row, element, cell) in
                cell.configureCell(element, selectedBooks: Array(output.selectedBooksDict.value.keys))
            }.disposed(by: disposeBag)

        output.toastMessage
            .asSignal()
            .emit(with: self) { owner, value in
                owner.showToast(message: value)
            }.disposed(by: disposeBag)
        
        output.scrollToTop
            .asSignal()
            .emit(with: self) { owner, _ in
                owner.main.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }.disposed(by: disposeBag)
    }
}
