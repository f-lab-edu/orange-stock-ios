//
//  KeychainItemManager.swift
//  orange-stock-ios
//
//  Created by hogang on 2023/12/19.
//

import Foundation

struct KeychainItemManager {
    
    // MARK: Keychain Error
    
    enum KeychainError: Error, Equatable {
        // 키체인에 저장 되어있지 않은 아이템
        case notFound
        // 중복된 아이템
        case duplicate
        // 유효하지 않은 형식
        case invalidItemFormat
        // 알 수 없는 오류
        case unknown(OSStatus)
    }
    
    // MARK: Account
    
    enum Account: String {
        case appleUserID
    }
    
    // MARK: Properties
    
    static let service = Bundle.main.bundleIdentifier
}

// MARK: - Keychain Access

extension KeychainItemManager {
    
    // MARK: Save
    
    static func save(account: Account, item: String, isForce: Bool = false) throws {
        try save(account: account, item: item.data(using: .utf8)!, isForce: isForce)
    }
    
    static func save(account: Account, item: Data, isForce: Bool = false) throws {
        let query: [String: AnyObject] = [
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account.rawValue as AnyObject,
            kSecClass as String: kSecClassGenericPassword,
            kSecValueData as String: item as AnyObject,
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        if let error = KeychainItemManager().errorWithstatus(status) {
            if error == .duplicate && isForce {
                try update(account: account, item: item)
            } else {
                throw error
            }
        }
    }
    
    // MARK: Read
    
    static func read(account: Account) throws -> String {
        try String(decoding: read(account: account), as: UTF8.self)
    }
    
    static func read(account: Account) throws -> Data {
        let query: [String: AnyObject] = [
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account.rawValue as AnyObject,
            kSecClass as String: kSecClassGenericPassword,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: kCFBooleanTrue,
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if let error = KeychainItemManager().errorWithstatus(status) {
            throw error
        } else {
            if let password = result as? Data {
                return password
            } else {
                throw KeychainError.invalidItemFormat
            }
        }
    }
    
    // MARK: Update
    
    static func update(account: Account, item: String) throws {
        try update(account: account, item:item.data(using: .utf8)!)
    }
    
    static func update(account: Account, item: Data) throws {
        let query: [String: AnyObject] = [
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account.rawValue as AnyObject,
            kSecClass as String: kSecClassGenericPassword,
            kSecValueData as String: item as AnyObject,
        ]
        
        let attributes: [String: AnyObject] = [
            kSecValueData as String: item as AnyObject
        ]
        
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        if let error = KeychainItemManager().errorWithstatus(status) {
            throw error
        }
    }
    
    // MARK: Delete
    
    static func delete(account: Account) throws {
        let query: [String: AnyObject] = [
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account.rawValue as AnyObject,
            kSecClass as String: kSecClassGenericPassword
        ]
        let status = SecItemDelete(query as CFDictionary)
        if let error = KeychainItemManager().errorWithstatus(status) {
            throw error
        }
    }
    
    private func errorWithstatus(_ status: OSStatus) -> KeychainError? {
        switch status {
        case errSecSuccess:
            return nil
        case errSecItemNotFound:
            return KeychainError.notFound
        case errSecDuplicateItem:
            return KeychainError.duplicate
        default:
            return KeychainError.unknown(status)
        }
    }
}

