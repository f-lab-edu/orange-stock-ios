//
//  OAuthAPI.swift
//  orange-stock-ios
//
//  Created by hogang on 2023/12/04.
//

import Foundation
import Moya

/// OAuth 인증 API 설정
enum OAuthAPI {
    // 접근토큰발급
    case issueAccessToken
    // 접근토큰폐기
    case revokeAccessToken(_ token: String)
}

extension OAuthAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: NetworkConfig.baseURL)!
    }
    
    var path: String {
        switch self {
        case .issueAccessToken:
            return "/oauth2/token"
        case .revokeAccessToken:
            return "/oauth2/revoke"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Moya.Task {
        return .requestParameters(parameters: parameter ?? [:],
                                  encoding: URLEncoding.httpBody)
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/x-www-form-urlencoded"]
    }
    
    var parameter: [String: Any]? {
        switch self {
        case .issueAccessToken:
            return [
                "grant_type": "client_credentials",
                "appkey": NetworkConfig.appKey,
                "appsecretkey": NetworkConfig.appSecretKey,
                "scope": "oob"
            ]
        case .revokeAccessToken(let token):
            return [
                "appkey": NetworkConfig.appKey,
                "appsecretkey": NetworkConfig.appSecretKey,
                "token_type_hint": "access_token",
                "token": token
            ]
        }
    }
}
