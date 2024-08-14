//
//  FeedViewController.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/13/24.
//

import UIKit
import Alamofire

final class FeedViewController: BaseViewController {
    override func bind() {
        let request = try! AuthorizationRouter.refreshToken
        AF.request(request).responseString { response in
            print(response)
        }
    }
}
