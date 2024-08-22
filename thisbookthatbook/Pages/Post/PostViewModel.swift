//
//  PostViewModel.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/23/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PostViewModel: BaseViewModel {
    
    let postId = BehaviorRelay(value: "")

    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(_ input: Input) -> Output {
        return Output()
    }
}
