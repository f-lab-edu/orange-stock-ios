//
//  Token.swift
//  orange-stock-ios
//
//  Created by hogang on 2023/12/02.
//

import Foundation

/// Model: AccessToken
struct Token: Codable {
    let accessToken: String
    let expiresIn: Int
    let tokenType: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
    }
}

/// Mode:  Revoke Token시 Response
struct TokenRevokeResponse: Codable {
    let code: Int
    let message: String
}

