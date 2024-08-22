//
//  ImageFetcher.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/22/24.
//

import Foundation
import Kingfisher

final class ImageFetcher {
    private init() { }
    static let shared = ImageFetcher()
    
    let version = "v1/"
    
    struct ImageData {
        let url: URL
        let idx: Int
        let modifier: AnyModifier
    }
    
    func getImagesFromServer(_ paths: [String], completionHandler: @escaping ((ImageData) -> Void)) {
        for (idx, value) in paths.enumerated() {
            guard let url = URL(string: API.baseURL + version + value) else { return }
            let request = AnyModifier { request in
                var requestBody = request
                let accessToken = UserDefaultsManager.shared.accessToken
                requestBody.setValue(accessToken, forHTTPHeaderField: API.Headers.auth)
                requestBody.setValue(API.key, forHTTPHeaderField: API.Headers.sesacKey)
                return requestBody
            }
            let data = ImageData(url: url, idx: idx, modifier: request)
            completionHandler(data)
        }
    }
}
