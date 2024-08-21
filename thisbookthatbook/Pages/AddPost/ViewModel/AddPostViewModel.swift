//
//  AddPostViewModel.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/21/24.
//

import UIKit
import RxSwift
import RxCocoa

final class AddPostViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    
    var images = PublishRelay<[UIImage]>()
    var imageNames = PublishRelay<[String?]>()
    
    struct Input {
        let didBeginEditing: ControlEvent<Void>
        let didEndEditing: ControlEvent<Void>
        let content: ControlProperty<String>
        let addPhotoBtnTapped: ControlEvent<Void>
        let removePhotoIdx: PublishRelay<Int>
        let addBookBtnTapped: ControlEvent<Void>
        let selectedBooks: PublishRelay<[Book]>
    }
    
    struct Output {
        let images: BehaviorRelay<[UIImage]>
        let beginEditingResult: PublishRelay<Bool>
        let endEditingResult: PublishRelay<Bool>
        let addPhotoBtnTapped: ControlEvent<Void>
        let addBookBtnTapped: ControlEvent<Void>
        let selectedBooks: BehaviorRelay<[String]>
    }
    
    func transform(_ input: Input) -> Output {
        let beginEditingResult = PublishRelay<Bool>()
        let endEditingResult = PublishRelay<Bool>()
        let outputImages: BehaviorRelay<[UIImage]> = BehaviorRelay(value: [])
        let outputImageNames: BehaviorRelay<[String?]> = BehaviorRelay(value: [])
        let selectedBooks: BehaviorRelay<[Book]> = BehaviorRelay(value: [])
        var contents: [String] = []
        let outputSelectedBooks: BehaviorRelay<[String]> = BehaviorRelay(value: [])
        // 포스트에 포함할 이미지 불러왔을 때
        images
            .bind(to: outputImages)
            .disposed(by: disposeBag)
        
        // 이미지 등록 해제할 때
        input.removePhotoIdx
            .bind(with: self) { owner, idx in
                // 현재 보여주고 있는 이미지에서 지워주기
                var currentImageList = outputImages.value
                currentImageList.remove(at: idx)
                outputImages.accept(currentImageList)
                // 등록되어있던 이미지 파일명 배열에서 데이터 지우기
                var currentImageNameList = outputImageNames.value
                currentImageNameList.remove(at: idx)
                outputImageNames.accept(currentImageNameList)
            }.disposed(by: disposeBag)
        
        // 포스트에 포함할 이미지의 파일명 불러왔을 때
        imageNames
            .bind(to: outputImageNames)
            .disposed(by: disposeBag)
        
        // 텍스트뷰 입력이 시작됐을 때, 원래있던 텍스트가 placeholder였는지
        input.didBeginEditing
            .withLatestFrom(input.content)
            .map { $0 == "placeholder_write_post".localized }
            .bind(to: beginEditingResult)
            .disposed(by: disposeBag)
        
        // 텍스트뷰 입력이 끝났을 때, 아무것도 입력하지 않았는지
        input.didEndEditing
            .withLatestFrom(input.content)
            .map { $0.isEmpty }
            .bind(to: endEditingResult)
            .disposed(by: disposeBag)
        
        input.selectedBooks
            .bind { book in
                let data = book.map { "\($0.title)#\($0.author)#\(book.publisher)#\($0.image)#\($0.description)#\($0.isbn)"}
                outputSelectedBooks.accept(data)
            }.disposed(by: disposeBag)
        
        return Output(images: outputImages, beginEditingResult: beginEditingResult, 
                      endEditingResult: endEditingResult, addPhotoBtnTapped: input.addPhotoBtnTapped,
                      addBookBtnTapped: input.addBookBtnTapped, selectedBooks: outputSelectedBooks)
    }
}
