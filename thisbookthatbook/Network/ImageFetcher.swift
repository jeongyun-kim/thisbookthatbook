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
        let idx: Int?
        let modifier: AnyModifier
    }
    
    func getImagesFromServer(_ paths: [String], completionHandler: @escaping ((ImageData) -> Void)) {
        for (idx, value) in paths.enumerated() {
            guard let url = configureURL(value) else { return }
            let request = configureModifier()
            let data = ImageData(url: url, idx: idx, modifier: request)
            completionHandler(data)
        }
    }
    
    func getAnImageFromServer(_ path: String, completionHandler: @escaping ((ImageData) -> Void)) {
        guard let url = configureURL(path) else { return }
        let request = configureModifier()
        let data = ImageData(url: url, idx: nil, modifier: request)
        completionHandler(data)
    }
    
    private func configureURL(_ path: String) -> URL? {
        guard let url = URL(string: API.baseURL + version + path) else { return nil }
        return url
    }
    
    private func configureModifier() -> AnyModifier {
        let request = AnyModifier { request in
            var requestBody = request
            let accessToken = UserDefaultsManager.shared.accessToken
            requestBody.setValue(accessToken, forHTTPHeaderField: API.Headers.auth)
            requestBody.setValue(API.key, forHTTPHeaderField: API.Headers.sesacKey)
            return requestBody
        }
        return request
    }
}
