//
//  UserDefaultsManager.swift
//  thisbookthatbook
//
//  Created by 김정윤 on 8/13/24.
//

import Foundation

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private init() { }
    
    @propertyWrapper struct UD {
        var key: String
        
        init(key: String) {
            self.key = key
        }
        
        var wrappedValue: String {
            get {
                UserDefaults.standard.string(forKey: key) ?? ""
            }
            set {
                UserDefaults.standard.setValue(newValue, forKey: key)
            }
        }
    }
    
    @UD(key: "accessToken") var accessToken
    @UD(key: "refreshToken") var refreshToken 
    @UD(key: "id") var id
    
    func deleteAllData() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key)
        }
    }
}
