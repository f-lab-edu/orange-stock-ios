//
//  OAuthAPIService.swift
//  orange-stock-ios
//
//  Created by hogang on 2023/12/03.
//

import Foundation
import Moya

/// OAuth 인증 API 호출
final class OAuthAPIService {
    
    let provider = MoyaProvider<OAuthAPI>()
    
    // accessToken 발행
    func issueAccessToken(completion: @escaping (Result<Token, Error>) -> Void) {
        request(target: .issueAccessToken, completion: completion)
    }
    
    // accessToken 폐기
    func revokeAccessToken(_ token: String,
                           completion: @escaping (Result<TokenRevokeResponse, Error>) -> Void) {
        request(target: .revokeAccessToken(token), completion: completion)
    }
}

private extension OAuthAPIService {
    
    func request<T: Decodable>(target: OAuthAPI,
                               completion: @escaping (Result<T, Error>) -> Void) {
        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(results))
                } catch let error {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
