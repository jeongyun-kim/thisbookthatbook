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
    
    @propertyWrapper struct UD<T> {
        var key: String
        var defaultValue: T
        
        init(key: String, defaultValue: T) {
            self.key = key
            self.defaultValue = defaultValue
        }
        
        var wrappedValue: T {
            get {
                UserDefaults.standard.value(forKey: key) as? T ?? defaultValue
            }
            set {
                UserDefaults.standard.setValue(newValue, forKey: key)
            }
        }
    }

    @UD(key: "accessToken", defaultValue: "") var accessToken
    @UD(key: "refreshToken", defaultValue: "") var refreshToken
    @UD(key: "id", defaultValue: "") var id
    @UD(key: "followings", defaultValue: Array<String>()) var followings
    
    func deleteAllData() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key)
        }
    }
}
