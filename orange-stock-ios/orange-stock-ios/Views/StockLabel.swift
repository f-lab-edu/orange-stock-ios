//
//  StockLabel.swift
//  orange-stock-ios
//
//  Created by hogang on 1/30/24.
//

import UIKit

// MARK: Protocol

protocol StockLabelAttributes {
    var textAlignment: NSTextAlignment { get }
    var font: UIFont { get }
    
    func text(with text: String) -> String
    func textColor(with diffSign: Stock.DiffSign) -> UIColor
}

// MARK: Structs

/// 관심 종목 - 종목명
struct FavoriteStockNameLabelAttributes: StockLabelAttributes {
    var textAlignment: NSTextAlignment = .left
    var font: UIFont = .titleLabel
    
    func text(with text: String) -> String {
        text
    }
    
    func textColor(with diffSign: Stock.DiffSign) -> UIColor {
        .basic
    }
}

/// 관심종목 - 가격
struct FavoriteStockPriceLabelAttributes: StockLabelAttributes {
    var textAlignment: NSTextAlignment = .right
    var font: UIFont = .titleLabel
    
    func text(with text: String) -> String {
        text.makeDecimal()
    }
    
    func textColor(with diffSign: Stock.DiffSign) -> UIColor {
        diffSign.color()
    }
}

/// 관심종목 - 등락
struct FavoriteStockRateLabelAttributes: StockLabelAttributes {
    var textAlignment: NSTextAlignment = .right
    var font: UIFont = .titleLabel
    
    func text(with text: String) -> String {
        "\(text)%"
    }
    
    func textColor(with diffSign: Stock.DiffSign) -> UIColor {
        diffSign.color()
    }
}

// MARK: Class - Label

/// VIew: 주식 정보 표기
class StockLabel: UILabel {
    
    // MARK: Properties
    
    private var attributes: StockLabelAttributes?
    
    // MARK: Attributes
    
    func setAttributes(attr: StockLabelAttributes) {
        self.attributes = attr
        textAlignment = attr.textAlignment
        font = attr.font
        
        textColor = .basic
    }
    
    func updateStockData(with data: String) {
        guard let attributes = attributes else { return }
        text = attributes.text(with: data)
    }
    
    func updateTextColor(with diffSign: Stock.DiffSign) {
        guard let attributes = attributes else { return }
        textColor = attributes.textColor(with: diffSign)
    }
}
