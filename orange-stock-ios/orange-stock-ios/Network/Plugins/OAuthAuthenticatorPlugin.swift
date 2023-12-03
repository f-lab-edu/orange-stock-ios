//
//  OAuthAuthenticatorPlugin.swift
//  orange-stock-ios
//
//  Created by hogang on 2023/12/03.
//

import Foundation
import Moya

/// Plugin: access token 미발행 및 만료 등, 토큰 관련 에러 확인 및 access token 재발행
struct OAuthAuthenticatorPlugin: PluginType {
    
    /// Called after a response has been received
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case .success(let response):
            onSuccess(response: response, target: target)
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    // 네트워크 호출 성공 시
    func onSuccess(response: Response, target: TargetType) {
        // 토큰 만료, 토큰 미발행에 관한 오류 statusCode는 500이다.
        if response.statusCode == 500 {
            do {
                let responseMessage = try JSONDecoder().decode(ResponseMessage.self, from: response.data)
                switch responseMessage.code {
                case .invaildToken, .unissuedToken:
                    reRequestAccessToken()
                default:
                    return
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func reRequestAccessToken() {
        OAuthAPIService().accessToken { result in
            switch result {
            case .success(let token):
                UserDefaultsManager.shared.setAccessToken(token)
            case .failure(let error):
                // TODO: Error 처리 어떻게 할지
                print(error.localizedDescription)
            }
        }
    }
}
