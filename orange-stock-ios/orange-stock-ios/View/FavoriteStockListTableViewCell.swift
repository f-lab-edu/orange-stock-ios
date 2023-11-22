//
//  FavoriteStockListTableViewCell.swift
//  orange-stock-ios
//
//  Created by hogang on 2023/11/20.
//

import UIKit
import SnapKit

/// View: 관심 주식 목록의 종목 Cell

final class FavoriteStockListTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    private var stockLabels: [StockLabel]!
    
    // MARK: Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Pubilc Method
    
    func stock(_ stock: Stock?) {
        guard let stock = stock else { return }
        self.stockLabels.forEach {
            $0.stock(stock)
        }
    }
}

// MARK: Layout

private extension FavoriteStockListTableViewCell {

    private enum Metric {
        static let stackViewSpacing = 4.0
        static let stackViewInset = 10.0
        static let stackViewHeight = 30.0
        static let currentPriceLabelWidth = 100.0
        static let spacingViewWidth = 14.0
        static let prevDayDiffSignLabelWidth = 14.0
        static let prevDayDiffPriceLabelWidth = 48.0
        static let prevDayDiffRateLabelWidth = 64.0
    }
    
    func layout() {
        let stackView = makeStackView()
        contentView.addSubview(stackView)
        
        let stockLabels = makeStockLabels()
        stockLabels.forEach {
            stackView.addArrangedSubview($0)
        }
        
        addStackViewContraints(stackView)
        addStockLabelsConstraint(stockLabels)
    }
    
    func makeStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Metric.stackViewSpacing
        return stackView
    }
    
    func makeStockLabels() -> [StockLabel] {
        let stockNameLabel = StockLabel(type: .stockName)
        let currentPriceLabel = StockLabel(type: .currentPrice)
        let spacingView = StockLabel()
        let prevDayDiffSignLabel = StockLabel(type: .prevDayDiffSign)
        let prevDayDiffPriceLabel = StockLabel(type: .prevDayDiffPrice)
        let prevDayDiffRateLabel = StockLabel(type: .prevDayDiffRate)
        
        self.stockLabels = [stockNameLabel, currentPriceLabel, prevDayDiffSignLabel, prevDayDiffSignLabel, prevDayDiffPriceLabel, prevDayDiffRateLabel]
        
        return [stockNameLabel, currentPriceLabel, spacingView, prevDayDiffSignLabel, prevDayDiffPriceLabel, prevDayDiffRateLabel]
    }
    
    func addStackViewContraints(_ stackView: UIStackView) {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Metric.stackViewInset)
            $0.height.equalTo(Metric.stackViewHeight)
        }
    }
    
    func addStockLabelsConstraint(_ views: [StockLabel]) {
        addStockLabel(views[5], constraint: Metric.prevDayDiffRateLabelWidth)
        addStockLabel(views[4], constraint: Metric.prevDayDiffPriceLabelWidth)
        addStockLabel(views[3], constraint: Metric.prevDayDiffSignLabelWidth)
        addStockLabel(views[2], constraint: Metric.spacingViewWidth)
        addStockLabel(views[1], constraint: Metric.currentPriceLabelWidth)
    }
    
    func addStockLabel(_ view: UIView, constraint width: CGFloat) {
        view.snp.makeConstraints {
            $0.width.equalTo(width)
        }
    }
}

class StockLabel: UILabel {
    
    enum StockType {
        case stockName
        case currentPrice
        case prevDayDiffSign
        case prevDayDiffPrice
        case prevDayDiffRate
        
        func changeTextColor() -> Bool {
            return self != .stockName
        }
        
        func textAlignment() -> NSTextAlignment {
            return self == .stockName ? .left : .right
        }
    }
    
    private var type: StockType?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(type: StockType) {
        self.init(frame: .zero)
        
        self.type = type
        
        self.textAlignment = type.textAlignment()
        self.textColor = Color.basic
        self.font = Font.titleLabel
    }
    
    func stock(_ stock: Stock) {
        self.text = text(stock)
        self.textColor = textColor(stock.prevDayDiffSign)
    }
    
    private func textColor(_ diffSign: Stock.DiffSign) -> UIColor {
        guard let type = self.type else { return Color.basic }
        return type.changeTextColor() ? diffSign.color() : Color.basic
    }
    
    private func text(_ stock: Stock) -> String {
        switch type {
        case .stockName:
            return stock.stockName
        case .currentPrice:
            return stock.currentPrice.makeDecimal()
        case .prevDayDiffSign:
            return stock.prevDayDiffSign.mark()
        case .prevDayDiffPrice:
            return stock.prevDayDiffPrice.makeDecimal()
        case .prevDayDiffRate:
            return "\(stock.prevDayDiffRate)%"
        case .none:
            return ""
        }
    }
}
