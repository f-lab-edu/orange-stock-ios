//
//  TokenRevokeResponse.swift
//  orange-stock-ios
//
//  Created by hogang on 2023/12/17.
//

import Foundation

/// Model:  Revoke Token시 Response
struct TokenRevokeResponse: Codable {
    let code: Int
    let message: String
}
