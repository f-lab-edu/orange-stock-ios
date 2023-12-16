//
//  NetworkConfig.swift
//  orange-stock-ios
//
//  Created by hogang on 2023/12/03.
//

import Foundation

/// 네트워크 통신에 필요한 기본 값
enum NetworkConfig {
    /// base URL
    static let baseURL = "https://openapi.ebestsec.co.kr:8080"
    
    /// 이베스트 OpenAPI 호출시 필요한 app key
    static let appKey = Bundle.main.infoDictionary?["API_APP_KEY"] as? String ?? ""
    
    /// 이베스트 OpenAPI 호출시 필요한 app secret key
    static let appSecretKey = Bundle.main.infoDictionary?["API_APP_SECRET"] as? String ?? ""
}
