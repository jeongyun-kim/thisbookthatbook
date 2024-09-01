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
    
    // 포스트 타입
    var productId = BehaviorRelay(value: RecommendType.give_recommend)
    // stackView 내 이미지뷰에 보여줄 이미지들
    var images = PublishRelay<[UIImage]>()
    // 게시할 이미지 데이터들
    var imageDatas: BehaviorRelay<[Data?]> = BehaviorRelay(value: [])
    // 게시할 이미지명들
    var imageNames: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    
    struct Input {
        let didBeginEditing: ControlEvent<Void>
        let didEndEditing: ControlEvent<Void>
        let content: ControlProperty<String>
        let addPhotoBtnTapped: ControlEvent<Void>
        let removePhotoIdx: PublishRelay<Int>
        let addBookBtnTapped: ControlEvent<Void>
        let selectedBooks: PublishRelay<[Book]>
        let postBtnTapped: ControlEvent<()>?
        let addPriceBtnTapped: ControlEvent<Void>
        let addedPrice: PublishRelay<String?>
    }
    
    struct Output {
        let images: BehaviorRelay<[UIImage]>
        let beginEditingResult: PublishRelay<Bool>
        let endEditingResult: PublishRelay<Bool>
        let addPhotoBtnTapped: ControlEvent<Void>
        let addBookBtnTapped: ControlEvent<Void>
        let selectedBooks: BehaviorRelay<[String]>
        let postBtnEnabled: BehaviorRelay<Bool>
        let viewType: BehaviorRelay<RecommendType>
        let postBtnTapped: PublishRelay<Void>
        let toastMessage: PublishRelay<String>
        let isExpiredTokenError: PublishRelay<Bool>
        let price: BehaviorRelay<String>
    }
    
    func transform(_ input: Input) -> Output {
        let beginEditingResult = PublishRelay<Bool>() // 입력시작했을 때
        let endEditingResult = PublishRelay<Bool>() // 입력 끝났을 때
        let outputImages: BehaviorRelay<[UIImage]> = BehaviorRelay(value: []) // 게시할 이미지 배열
        let outputSelectedBooks: BehaviorRelay<[String]> = BehaviorRelay(value: []) // 게시할 책 정보
        let postBtnEnabled = BehaviorRelay(value: false) // 게시 버튼 사용 가능 여부
        let outputPostBtnTapped = PublishRelay<Void>() // 게시 버튼 눌렀을 때
        let toastMessage = PublishRelay<String>()
        let isExpiredTokenError = PublishRelay<Bool>()
        let priceForView = BehaviorRelay(value: "label_free".localized)
        
        // Data
        let content = BehaviorRelay(value: "") // 포스트 본문
        var bookList = ["", "", "", "", ""] // 저장할 책 데이터 리스트
        let priceForSave = BehaviorRelay(value: 0) // 저장할 가격 정보
        
        
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
                var currentImageNameList = owner.imageNames.value
                currentImageNameList.remove(at: idx)
                owner.imageNames.accept(currentImageNameList)
            }.disposed(by: disposeBag)
        
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
        
        // 책 검색뷰에서 책 선택해서 돌아왔을 때
        input.selectedBooks
            .bind { book in
                // 책 데이터 구성
                let data = book.map { "\($0.title)#\($0.author)#\($0.publisher)#\($0.image)#\($0.description)#\($0.isbn)"}
                for (idx, value) in data.enumerated() {
                    bookList[idx] = value
                }
                // ""인 데이터는 output으로 보내지 않기
                // - ""인 데이터가 포함되면 책 정보가 없는 셀도 생겨남
                let result = bookList.filter { !$0.isEmpty }
                outputSelectedBooks.accept(result)
            }.disposed(by: disposeBag)
        
        // 포스트 내용
        input.content
            .map { $0 != "placeholder_write_post".localized }
            .bind(to: postBtnEnabled)
            .disposed(by: disposeBag)
        
        // 포스트 내용 입력할 때마다 포스트 내용 받아오기
        input.content
            .bind(to: content)
            .disposed(by: disposeBag)
        
        // 가격이 입력됐을 때 -> Int로 변환해서 가지고 있기
        input.addedPrice
            .compactMap { $0 }
            .compactMap { Int($0) }
            .bind(to: priceForSave)
            .disposed(by: disposeBag)
        
        // Int로 변환한 가격이 0원인지 확인 -> 0원이면 무료 : \(가격)P 
        input.addedPrice
            .withLatestFrom(priceForSave)
            .map { $0 == 0 }
            .map { $0 ? "label_free".localized : "\(priceForSave.value)P" }
            .bind(to: priceForView)
            .disposed(by: disposeBag)
            
        
        // 게시버튼 눌렀을 때
        if let postBtnTapped = input.postBtnTapped {
            postBtnTapped
                .throttle(.seconds(10), scheduler: MainScheduler.instance)
                .bind(with: self) { owner, value in
                    let files = owner.imageDatas.value // 게시할 이미지
                    let fileNames = owner.imageNames.value // 게시할 이미지명
                    let productId = owner.productId.value // product_id
                    let query  = UploadPostQuery(content: content.value, content1: bookList[0], content2: bookList[1], content3: bookList[2], content4: bookList[3], content5: bookList[4], product_id: productId, price: priceForSave.value, files: fileNames)
                    
                    NetworkService.shared.postImages(query: query, files: files, fileNames: fileNames) { error in
                        switch error {
                        case .expiredToken:
                            isExpiredTokenError.accept(true)
                        case .invalidPostRequest:
                            isExpiredTokenError.accept(false)
                        default:
                            toastMessage.accept("toast_default_error".localized)
                        }
                    }
                    outputPostBtnTapped.accept(())
                }.disposed(by: disposeBag)
        }
        
        return Output(images: outputImages, beginEditingResult: beginEditingResult, 
                      endEditingResult: endEditingResult, addPhotoBtnTapped: input.addPhotoBtnTapped,
                      addBookBtnTapped: input.addBookBtnTapped, selectedBooks: outputSelectedBooks,
                      postBtnEnabled: postBtnEnabled, viewType: productId, 
                      postBtnTapped: outputPostBtnTapped, toastMessage: toastMessage,
                      isExpiredTokenError: isExpiredTokenError, price: priceForView)
    }
}
