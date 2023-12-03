//
//  ResponseMessage.swift
//  orange-stock-ios
//
//  Created by hogang on 2023/12/03.
//

import Foundation

/// Model: 토큰 관련 API 외 Open API의 Response Message
struct ResponseMessage: Codable {
    
    let message: String
    let code: ResponseCode
    
    enum CodingKeys: String,CodingKey {
        case message = "rsp_msg"
        case code = "rsp_cd"
    }
    
    enum ResponseCode: String, Codable {
        case success = "0000"
        case invaildToken = "IGW00121" // 유효하지 않은 토큰
        case unissuedToken = "IGW00205" // 토큰이 발행되지 않음
    }
}
