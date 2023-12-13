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
    
    // MARK: Enum - Constraint
    
    /// Constraint
    private enum Metric {
        static let stackViewSpacing = 4.0
        static let stackViewInset = 10.0
        static let stackViewHeight = 30.0
        static let currentPriceLabelWidth = 100.0
        static let prevDayDiffSignLabelWidth = 28.0
        static let prevDayDiffPriceLabelWidth = 48.0
        static let prevDayDiffRateLabelWidth = 64.0
    }
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Pubilc Method
    
    func stock(_ stock: Stock?) {
        guard let stock = stock else { return }
        self.stockLabels.forEach {
            $0.stock(stock)
        }
    }
}

// MARK: - Layout

private extension FavoriteStockListTableViewCell {
    
    func layout() {
        let stackView = makeStackView()
        contentView.addSubview(stackView)
        
        self.stockLabels = makeStockLabels()
        self.stockLabels.forEach {
            stackView.addArrangedSubview($0)
        }
        
        addStackViewContraints(stackView)
        addStockLabelsConstraint(self.stockLabels)
    }
    
    // MARK: UIComponets
    
    func makeStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Metric.stackViewSpacing
        return stackView
    }
    
    func makeStockLabels() -> [StockLabel] {
        let stockNameLabel = StockLabel(type: .stockName)
        let currentPriceLabel = StockLabel(type: .currentPrice)
        let prevDayDiffSignLabel = StockLabel(type: .prevDayDiffSign)
        let prevDayDiffPriceLabel = StockLabel(type: .prevDayDiffPrice)
        let prevDayDiffRateLabel = StockLabel(type: .prevDayDiffRate)
        return [stockNameLabel, currentPriceLabel, prevDayDiffSignLabel, prevDayDiffPriceLabel, prevDayDiffRateLabel]
    }
    
    // MARK: Contraints
    
    func addStackViewContraints(_ stackView: UIStackView) {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Metric.stackViewInset)
            $0.height.equalTo(Metric.stackViewHeight)
        }
    }
    
    func addStockLabelsConstraint(_ views: [StockLabel]) {
        addStockLabel(views[4], constraint: Metric.prevDayDiffRateLabelWidth)
        addStockLabel(views[3], constraint: Metric.prevDayDiffPriceLabelWidth)
        addStockLabel(views[2], constraint: Metric.prevDayDiffSignLabelWidth)
        addStockLabel(views[1], constraint: Metric.currentPriceLabelWidth)
    }
    
    func addStockLabel(_ view: StockLabel, constraint width: CGFloat) {
        view.snp.makeConstraints {
            $0.width.equalTo(width)
        }
    }
}

/// Label: 주식 정보 표기
class StockLabel: UILabel {
    
    /// 표기할 정보 타입
    enum StockInfoType {
        case stockName
        case currentPrice
        case prevDayDiffSign
        case prevDayDiffPrice
        case prevDayDiffRate
        
        func textAlignment() -> NSTextAlignment {
            return self == .stockName ? .left : .right
        }
    }
    
    // MARK: Properties
    
    private var type: StockInfoType
    
    // MARK: Init
    
    override init(frame: CGRect) {
        self.type = .stockName
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(type: StockInfoType) {
        self.init(frame: .zero)
        
        self.type = type
        
        self.textAlignment = type.textAlignment()
        self.textColor = .basic
        self.font = .titleLabel
    }
    
    // MARK: Public Methods
    
    func stock(_ stock: Stock) {
        self.text = text(stock)
        self.textColor = textColor(stock.prevDayDiffSign)
    }
    
    // MARK: Private Methods
    
    private func textColor(_ diffSign: Stock.DiffSign) -> UIColor {
        return type == .stockName ? .basic : diffSign.color()
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
        }
    }
}
