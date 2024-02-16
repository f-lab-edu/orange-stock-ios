//
//  OAuthAPIService.swift
//  orange-stock-ios
//
//  Created by hogang on 2023/12/03.
//

import Foundation
import Moya

/// OAuth 인증 API 호출
final class OAuthAPIService: APIServiceProviderProtocol {
    
    typealias T = OAuthAPI
    
    var provider: MoyaProvider<T>
    
    init(isStub: Bool = false,
         sampleStatusCode: Int = 200,
         customEndpointClosure: ((T) -> Moya.Endpoint)? = nil) {
        provider = MoyaProvider<T>()
    }
    
    // accessToken 발행
    func issueAccessToken(completion: @escaping (Result<Token, Error>) -> Void) {
        request(provider: provider, target: .issueAccessToken, completion: completion)
    }
    
    // accessToken 폐기
    func revokeAccessToken(_ token: String,
                           completion: @escaping (Result<TokenRevokeResponse, Error>) -> Void) {
        request(provider: provider, target: .revokeAccessToken(token), completion: completion)
    }
}
