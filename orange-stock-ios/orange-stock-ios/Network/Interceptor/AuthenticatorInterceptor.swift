//
//  AuthenticatorInterceptor.swift
//  orange-stock-ios
//
//  Created by hogang on 2023/12/05.
//

import Foundation
import Alamofire

final class AuthenticatorInterceptor: RequestInterceptor {
    
    /// adapter 역할은 Moya의 AccessTokenPlugin이 담당

    /// access token이 유효하지 않다면 access token 갱신한다.
    func retry(_ request: Request,
               for session: Session,
               dueTo error: Error,
               completion: @escaping (RetryResult) -> Void) {
        // access token을 갱신해야하는 상황이 아니라면 바로 리턴한다.
        guard needUpdateAccessToken(request: request) else {
            completion(.doNotRetryWithError(error))
            return
        }
        // access token 갱신 API 호출
        requestAccessToken { success, error in
            completion(
                success ? .retry : .doNotRetryWithError(error!)
            )
        }
    }
}

// MARK: Private Methods

extension AuthenticatorInterceptor {
    
    /// access token 갱신이 필요한지 확인
    func needUpdateAccessToken(request: Request) -> Bool {
        guard let data = (request as? DataRequest)?.data,
              let rspMsg = decode(ResponseMessage(), from: data),
              let code = rspMsg.code
        else { return false }
        
        return code.isTokenErrorCode
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
