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
    init(vm: AddPostViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.vm = vm
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
    }
    
    override func bind() {
        let didBeginEditing = main.contentTextView.rx.didBeginEditing
        let didEndEditing = main.contentTextView.rx.didEndEditing
        let content = main.contentTextView.rx.text.orEmpty
        let addPhotoBtnTapped = main.toolbar.photoButton.rx.tap
        let removePhotoIdx = PublishRelay<Int>()
        
        let input = AddPostViewModel.Input(didBeginEditing: didBeginEditing, didEndEditing: didEndEditing,
                                           content: content, addPhotoBtnTapped: addPhotoBtnTapped,
                                           removePhotoIdx: removePhotoIdx)
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
    }
}

// MARK: PHPickerVC+
extension AddPostViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // 선택한 이미지 배열
        var images: [UIImage] = []
        // 선택한 이미지의 파일명 배열
        var imageNames: [String?] = []
        
        for (idx, result) in results.enumerated() {
            guard idx < 3 else { return }
            
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        // 선택한 이미지
                        images.append(image)
                        self?.vm.images.accept(images)
                        // 선택한 이미지의 파일명
                        let imageName = result.itemProvider.suggestedName
                        imageNames.append(imageName)
                        self?.vm.imageNames.accept(imageNames)
                    }
                }
            }
        }
        dismiss(animated: true)
    }
  
}
