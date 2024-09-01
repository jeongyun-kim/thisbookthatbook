//
//  AddPostViewController.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/19/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import PhotosUI

final class AddPostViewController: BaseViewController {
    init(vm: AddPostViewModel, type: RecommendType) {
        super.init(nibName: nil, bundle: nil)
        self.vm = vm
        vm.productId.accept(type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var vm: AddPostViewModel!
    private let disposeBag = DisposeBag()
    private let main = AddPostView()

    override func loadView() {
        self.view = main
    }
    
    override func setupUI() {
        super.setupUI()
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "navigation_title_add".localized
        let post = UIBarButtonItem(title: "게시", style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = post
    }
    
    override func bind() {
        let didBeginEditing = main.contentTextView.rx.didBeginEditing
        let didEndEditing = main.contentTextView.rx.didEndEditing
        let content = main.contentTextView.rx.text.orEmpty
        let addPhotoBtnTapped = main.toolbar.photoButton.rx.tap
        let addBookBtnTapped = main.toolbar.bookButton.rx.tap
        let removePhotoIdx = PublishRelay<Int>()
        let selectedBooks = PublishRelay<[Book]>()
        let postBtnTapped = navigationItem.rightBarButtonItem?.rx.tap
        let addPriceBtnTapped = main.toolbar.addPriceButton.rx.tap
        let addedPrice = PublishRelay<String?>()
        
        let input = AddPostViewModel.Input(didBeginEditing: didBeginEditing, didEndEditing: didEndEditing,
                                           content: content, addPhotoBtnTapped: addPhotoBtnTapped,
                                           removePhotoIdx: removePhotoIdx, addBookBtnTapped: addBookBtnTapped, 
                                           selectedBooks: selectedBooks, postBtnTapped: postBtnTapped,
                                           addPriceBtnTapped: addPriceBtnTapped, addedPrice: addedPrice)
        let output = vm.transform(input)
        
        // 텍스트뷰에 입력 시작했을 때
        output.beginEditingResult
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, value in
                guard value else { return }
                owner.main.contentTextView.text = ""
                owner.main.contentTextView.textColor = Resource.Colors.black
            }.disposed(by: disposeBag)
        
        // 텍스트뷰 입력 끝났을 때
        output.endEditingResult
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, value in
                guard value else { return }
                owner.main.contentTextView.text = "placeholder_write_post".localized
                owner.main.contentTextView.textColor = Resource.Colors.lightGray
            }.disposed(by: disposeBag)
        
        // 텍스트뷰 툴바의 사진 추가 버튼 눌렀을 때 
        output.addPhotoBtnTapped
            .bind(with: self) { owner, _ in
                owner.main.picker.delegate = owner
                owner.transition(owner.main.picker, type: .present)
            }.disposed(by: disposeBag)
        
        // 등록하려는 이미지의 유무에 따라 컬렉션뷰 높이 설정
        output.images
            .map { !$0.isEmpty }
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, value in
                owner.main.configureCollectionViewHeight(value)
            }.disposed(by: disposeBag)
        
        // 등록하려는 이미지로 컬렉션뷰 그리기
        output.images
            .asDriver(onErrorJustReturn: [])
            .drive(main.photoCollectionView.rx.items(cellIdentifier: PhotoCollectionViewCell.identifier, cellType: PhotoCollectionViewCell.self)) { (row, element, cell) in
                cell.configureCell(element)
                // 이미지 제거버튼 눌렀을 때 선택한 이미지 제거
                cell.deleteButton.rx.tap
                    .throttle(.seconds(5), scheduler: MainScheduler.instance)
                    .map { _ in row }
                    .bind(to: removePhotoIdx)
                    .disposed(by: cell.disposeBag)
            }.disposed(by: disposeBag)
        
        // 책 추가 버튼 눌렀을 때
        // -> AddBookVC로부터 받아온 책 vm에 넣어주기
        output.addBookBtnTapped
            .asSignal()
            .emit(with: self) { owner, _ in
                let vc = AddBookViewController()
                owner.view.endEditing(true)
                vc.sendBooks = { books in
                    selectedBooks.accept(books)
                }
                owner.transition(vc)
            }.disposed(by: disposeBag)
        
        // 추천하려고 선택한 책들로 컬렉션뷰 그리기
        output.selectedBooks
            .asDriver()
            .drive(main.bookCollectionView.rx.items(cellIdentifier: BookCollectionViewCell.identifier, cellType: BookCollectionViewCell.self)) { (row, element, cell) in
                cell.configureCell(element)
            }.disposed(by: disposeBag)
        
        // 포스트 게시 버튼 사용 가능 여부
        output.postBtnEnabled
            .asDriver()
            .drive(with: self) { owner, value in
                let textColorCondition = owner.main.contentTextView.textColor == Resource.Colors.black
                let textCondition = !owner.main.contentTextView.text.isEmpty
                let isValid = value && textColorCondition && textCondition
                owner.navigationItem.rightBarButtonItem?.isEnabled = isValid
            }.disposed(by: disposeBag)
        
        // [추천해요 / 추천해주세요] 어떤 뷰에서 이동해왔느냐에 따라
        // - 추천해주세요로부터 왔으면 책 추천 버튼 숨기기
        output.viewType
            .map { $0 == .recieve_recommended }
            .bind(to: main.toolbar.bookButton.rx.isHidden,
                  main.toolbar.bookStackView.rx.isHidden, 
                  main.toolbar.addPriceButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        // 포스트 게시 버튼 탭
        output.postBtnTapped
            .asSignal()
            .emit(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
        
        // Alert으로 하는 에러 처리
        // - 토큰 갱신 실패
        // - 이미지와 이미지명 count 안 맞아서 인덱스 런타임 에러 방지
        output.isExpiredTokenError
            .asSignal()
            .emit(with: self) { owner, value in
                if value { // 토큰 갱신 실패 시 로그인뷰로
                    owner.showExpiredTokenAlert()
                } else { // 이미지 - 이미지명 매치 안돼서 런타임 에러날 수 있을 때
                    let message = "alert_invalid_post".localized
                    owner.showAlertOnlyConfirm(message: message) { _ in
                        owner.navigationController?.popViewController(animated: true)
                    }
                }
            }.disposed(by: disposeBag)
            
        
        // 기본 공통 에러 등
        output.toastMessage
            .asSignal()
            .emit(with: self) { owner, value in
                owner.showToast(message: value)
            }.disposed(by: disposeBag)
        
        main.toolbar.addPriceButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = AddPriceViewController()
                vc.sheetPresentationController?.detents = [.medium()]
                vc.sendPrice = { price in
                    addedPrice.accept(price)
                }
                owner.transition(vc, type: .present)
            }.disposed(by: disposeBag)
        
        output.price
            .bind(to: main.priceLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

// MARK: PHPickerVC+
extension AddPostViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // 선택한 이미지 데이터 배열
        var imageDatas: [Data?] = []
        // 선택한 이미지의 파일명 배열
        var imageNames: [String] = []
        // 선택한 이미지
        var images: [UIImage] = []
        
        for (idx, result) in results.enumerated() {
            guard idx < 3 else { return }
            
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        images.append(image)
                        self?.vm.images.accept(images)
                        // 선택한 이미지 데이터
                        imageDatas.append(image.pngData())
                        self?.vm.imageDatas.accept(imageDatas)
                        // 선택한 이미지의 파일명
                        guard let imageName = result.itemProvider.suggestedName else { return }
                        imageNames.append(imageName)
                        self?.vm.imageNames.accept(imageNames)
                    }
                }
            }
        }
        dismiss(animated: true)
    }
  
}

