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
        let removePhotoIdx: PublishRelay<Int>
    }
    
    struct Output {
        let images: BehaviorRelay<[UIImage]>
    }
    
    func transform(_ input: Input) -> Output {
        let outputImages: BehaviorRelay<[UIImage]> = BehaviorRelay(value: [])
        let outputImageNames: BehaviorRelay<[String?]> = BehaviorRelay(value: [])
        
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
        
        return Output(images: outputImages)
    }
}
