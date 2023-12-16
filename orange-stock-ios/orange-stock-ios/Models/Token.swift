//
//  Token.swift
//  orange-stock-ios
//
//  Created by hogang on 2023/12/02.
//

import Foundation

/// Model: AccessToken
struct Token: Codable {
    let accessToken: String // 접근토큰
    let expiresIn: Int // 접근토큰 유효기간(초)
    let tokenType: String // 토큰유형: Bearer
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
    }
}

/// Model:  Revoke Token시 Response
struct TokenRevokeResponse: Codable {
    let code: Int
    let message: String
}

