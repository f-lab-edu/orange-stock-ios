//
//  StockItem.swift
//  orange-stock-ios
//
//  Created by hogang on 2/14/24.
//

import Foundation

/// Model: 국내 주식 종목 리스트 - 종목 검색 시
struct StockItemList: ResponseMessageProtocol, Codable {
    
    typealias T = StockItem
    
    var code: String?
    var message: String?
    var items: [StockItem]?
    
    enum CodingKeys: String, CodingKey {
        case code = "rsp_cd"
        case message = "rsp_msg"
        case items = "t8436OutBlock"
    }
}

// MARK: - StockItem
/// Model: 국내 주식 종목 - 종목 검색 시
struct StockItem: Codable {
    let stockCode: String? // 종목코드
    let stockName: String? // 종목명
    let market: StockMarketType? // 코스피, 코스닥
    
    enum CodingKeys: String, CodingKey {
        case stockCode = "shcode"
        case stockName = "hname"
        case market = "gubun"
    }
}

/// 국내 주식 코스피 코스닥 구분
enum StockMarketType: String, Codable {
    case KOSPI = "1"
    case KOSDAQ = "2"
    
    var text: String {
        switch self {
        case .KOSPI:
            return "KOSPI"
        case .KOSDAQ:
            return "KOSDAQ"
        }
    }
}
