//
//  Stock.swift
//  orange-stock-ios
//
//  Created by hogang on 2023/11/23.
//

import UIKit

struct Stock {
    let stockCode: String // 종목코드
    let stockName: String // 종목명
    let currentPrice: String // 현재가
    let prevDayDiffSign: DiffSign // 전일 대비 부호
    let prevDayDiffPrice: String // 전일 대비
    let prevDayDiffRate: String // 전일 대비율
    
    enum DiffSign: Int {
        case upperLimit = 1 // 상한
        case increase       // 상승
        case stability      // 보합
        case lowerLimit     // 하한
        case decrease       // 하락
        
        func color() -> UIColor {
            switch self {
            case .upperLimit, .increase:
                return Color.stockUp
            case .stability:
                return Color.basic
            case .lowerLimit, .decrease:
                return Color.stockDown
            }
        }
        
        func mark() -> String {
            switch self {
            case .upperLimit, .increase:
                return "▲"
            case .stability:
                return "-"
            case .lowerLimit, .decrease:
                return "▼"
            }
        }
    }
}
