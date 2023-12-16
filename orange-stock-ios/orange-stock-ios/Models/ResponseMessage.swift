//
//  ResponseMessage.swift
//  orange-stock-ios
//
//  Created by hogang on 2023/12/03.
//

import Foundation

/// Model: OAuth를 제외한 Open API의 Response Message
struct ResponseMessage: Codable {
    
    var message: String? // 응답 메세지
    var code: ResponseCode? // 응답 코드
    
    enum CodingKeys: String,CodingKey {
        case message = "rsp_msg"
        case code = "rsp_cd"
    }
}

// MARK: Enum - Response Code

extension ResponseMessage {
    
    enum ResponseCode: String, Codable {
        case success = "0000" // 정상적으로 조회가 완료되었습니다.
        case insufficientTRCont = "IGW40010" // 연속구분(Cont)은 필수입니다.
        case insufficientTRCode = "IGW00214" // TR CD는 필수입니다.
        case invaildContentType = "IGW00133" // Content-Type이 유효하지 않습니다.
        case invaildShortCode = "IGW40011" // 단축코드(shcode) 길이 확인이 필요합니다.
        case invaildTRCode = "IGW00215" // 유효하지 않은 TR CD 입니다.
        case invaildToken = "IGW00121" // 유효하지 않은 token입니다.
        case unissuedToken = "IGW00205" // credentials_type이 유효하지 않습니다.(Bearer)
        
        /// 토큰 에러 코드인지 확인
        var isTokenErrorCode: Bool {
            self == .invaildToken || self == .unissuedToken
        }
    }
}
