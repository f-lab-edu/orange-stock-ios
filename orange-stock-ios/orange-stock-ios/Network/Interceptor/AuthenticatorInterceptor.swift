//
//  AuthenticatorInterceptor.swift
//  orange-stock-ios
//
//  Created by hogang on 2023/12/05.
//

import Foundation
import Alamofire

final class AuthenticatorInterceptor {
    
    // MARK: Properties
    
    static let shared = AuthenticatorInterceptor()
    
    // MARK: Enum
    
    private enum AccessTokenStatus {
        case vaild
        case invaild
        case networkError
    }
}

// MARK: - RequestInterceptor

extension AuthenticatorInterceptor: RequestInterceptor {

    /// adapter - AccessToken 삽입
    func adapt(_ urlRequest: URLRequest,
               for session: Session,
               completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard let accessToken = UserDefaultsManager.shared.getAccessToken()
        else {
            completion(.success(urlRequest))
            return
        }
        
        var newUrlRequest = urlRequest
        newUrlRequest.headers.add(.authorization(bearerToken: accessToken))
        completion(.success(newUrlRequest))
    }

    /// access token이 유효하지 않다면 access token 갱신한다.
    func retry(_ request: Request,
               for session: Session,
               dueTo error: Error,
               completion: @escaping (RetryResult) -> Void) {
        switch accessTokenStatus(request: request) {
        case .vaild:
            completion(.doNotRetry)
        case .networkError:
            completion(.doNotRetryWithError(error))
        case .invaild:
            // access token 갱신 API 호출
            requestAccessToken { success, error in
                completion(success ? .retry : .doNotRetryWithError(error!))
            }
        }
    }
}

// MARK: Private Methods

extension AuthenticatorInterceptor {
    
    /// access token 갱신이 필요한지 확인
    private func accessTokenStatus(request: Request) -> AccessTokenStatus {
        guard let data = (request as? DataRequest)?.data,
              let rspMsg = decode(ResponseMessage(), from: data)
        else { return .networkError }

        let isInvaildToken = rspMsg.code?.isTokenErrorCode ?? false
        return isInvaildToken ? .invaild : .vaild
    }
    
    /// access token 갱신 API
    func requestAccessToken(completion: @escaping (Bool, Error?) -> Void) {
        OAuthAPIService().issueAccessToken { result in
            switch result {
            case .success(let token):
                UserDefaultsManager.shared.setAccessToken(token)
                completion(true, nil)
            case .failure(let error):
                completion(false, error)
            }
        }
    }
    
    /// Json Decoding
    func decode<T: Codable>(_ type: T, from data: Data) -> T? {
        try? JSONDecoder().decode(T.self, from: data)
    }
}
