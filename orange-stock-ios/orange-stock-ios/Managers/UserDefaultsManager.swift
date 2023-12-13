//
//  UserDefaultsManager.swift
//  orange-stock-ios
//
//  Created by hogang on 2023/12/03.
//

import Foundation

/// UserDefaults 관리를 도와주는 Singleton Class
final class UserDefaultsManager {
    
    // MARK: Properties
    
    static let shared = UserDefaultsManager()
    
    // MARK: Enum - Key
    
    enum Key: String, CaseIterable {
        case accessToken
    }
    
    // MARK: Public Method
    
    /// Key에 정의한 모든 값을 유저디폴트에서 삭제
    func clearAll() {
        Key.allCases.forEach {
            UserDefaults.standard.removeObject(forKey: $0.rawValue)
        }
    }
    
    /// 특정 키만 삭제
    func clear(_ key: Key) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
}

// MARK: - AceessToken

extension UserDefaultsManager {
    /// accessToken 저장
    func setAccessToken(_ token: Token) {
        UserDefaults.standard.set(token.accessToken, forKey: Key.accessToken.rawValue)
    }
    
    /// accessToken 전달
    func getAccessToken() -> String {
        UserDefaults.standard.string(forKey: Key.accessToken.rawValue) ?? ""
    }
}
