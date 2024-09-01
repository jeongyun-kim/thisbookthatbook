//
//  AddBookViewModel.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/21/24.
//

import UIKit
import RxSwift
import RxCocoa

final class AddBookViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    
    var books: [Book] = []
   
   
    
    struct Input {
        let searchBtnTapped: ControlEvent<Void>
        let searchKeyword: ControlProperty<String>
        let prefetchRows: ControlEvent<[IndexPath]>
        let selectedModel: ControlEvent<Book>
    }
    
    struct Output {
        let searchResults: BehaviorRelay<[Book]>
        let toastMessage: PublishRelay<String>
        let scrollToTop: PublishRelay<Void>
        let selectedBooksDict: BehaviorRelay<[String: Book]>
    }
    
    func transform(_ input: Input) -> Output {
        let display = 10
        var totalPage = 0
        var page = 1
        
        var keyword = BehaviorRelay(value: "")
        let searchResults: BehaviorRelay<[Book]> = BehaviorRelay(value: [])
        let scrollToTop = PublishRelay<Void>()
        let toastMessage = PublishRelay<String>()
        let selectedBooksDict: BehaviorRelay<[String: Book]> = BehaviorRelay(value: [:])
         
        input.searchKeyword
            .bind(to: keyword)
            .disposed(by: disposeBag)
        
        input.searchBtnTapped
            .throttle(.seconds(5), scheduler: MainScheduler.instance)
            .withLatestFrom(keyword)
            .distinctUntilChanged()
            .flatMap { NetworkService.shared.fetchBooks(query: $0) }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let value):
                    searchResults.accept(value.items)
                    totalPage = value.total
                    page = 1
                    guard value.items.count > 0 else { return }
                    scrollToTop.accept(())
                case .failure(_):
                    toastMessage.accept(NetworkService.Errors.defaultError.rawValue.localized)
                }
            }.disposed(by: disposeBag)
        
        input.prefetchRows
            .compactMap { $0.first }
            .filter { $0.row == searchResults.value.count - 7 && page < totalPage }
            .withLatestFrom(keyword)
            .flatMap { NetworkService.shared.fetchBooks(query: $0, start: page + display) }
            .bind { result in
                switch result {
                case .success(let value):
                    var currentList = searchResults.value
                    currentList.append(contentsOf: value.items)
                    searchResults.accept(currentList)
                case .failure(_):
                    toastMessage.accept("toast_book_error".localized)
                }
            }.disposed(by: disposeBag)
        
        input.selectedModel
            .bind(with: self) { owner, book in
                var currentDict = selectedBooksDict.value
                let isbns = Array(currentDict.keys)
                
                if isbns.contains(book.isbn) {
                    currentDict.removeValue(forKey: book.isbn)
                    selectedBooksDict.accept(currentDict)
                } else {
                    if selectedBooksDict.value.count < 5 {
                        var currentDict = selectedBooksDict.value
                        currentDict[book.isbn] = book
                        selectedBooksDict.accept(currentDict)
                    } else {
                        toastMessage.accept("toast_book_limit".localized)
                    }
                }
                searchResults.accept(searchResults.value)
                owner.books = Array(selectedBooksDict.value.values)
            }.disposed(by: disposeBag)
       
        return Output(searchResults: searchResults, toastMessage: toastMessage, scrollToTop: scrollToTop, selectedBooksDict: selectedBooksDict)
    }
}
