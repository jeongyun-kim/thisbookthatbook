//
//  FeedViewModel.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/18/24.
//

import Foundation
import RxSwift
import RxCocoa

final class FeedViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let selectedSegmentIdx: ControlProperty<Int>
    }
    
    struct Output {
        let toastMessage: PublishRelay<String>
        let alert: PublishRelay<Void>
      //  let feedResults: PublishRelay<[Post]>
    }
    
    func transform(_ input: Input) -> Output {
        let toastMessage = PublishRelay<String>()
        let alert = PublishRelay<Void>()
        
        input.selectedSegmentIdx
            .map {
                let id = RecommendType.allCases[$0].rawValue
                let query = GetPostsQuery(next: "0", product_id: id)
                return query
            }
            .flatMap { NetworkService.shared.getPosts(query: $0) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    print("success", value)
                case .failure(let error):
                    switch error {
                    case .expiredToken:
                        // 토큰 갱신이 불가하다면 재로그인 필요
                        alert.accept(())
                        // 재로그인할거니까 저장해뒀던 사용자 정보 모두 지우기 -> 앱을 껐다키면 로그인 화면으로 이동 
                        UserDefaultsManager.shared.deleteAllData()
                    default:
                        toastMessage.accept("toast_default_error".localized)
                    }
                }
            }.disposed(by: disposeBag)
        
        let output = Output(toastMessage: toastMessage, alert: alert)
        return output
    }
}
