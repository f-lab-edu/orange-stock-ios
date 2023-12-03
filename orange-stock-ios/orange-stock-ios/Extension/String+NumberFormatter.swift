//
//  String+NumberFormatter.swift
//  orange-stock-ios
//
//  Created by hogang on 2023/11/28.
//

import Foundation

/// 숫자 세자리 단위 콤마  문자열로 변환
extension String {
    func makeDecimal() -> String {
        guard let intValue = Int64(self) else { return "" }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: intValue)) ?? ""
    }
}
