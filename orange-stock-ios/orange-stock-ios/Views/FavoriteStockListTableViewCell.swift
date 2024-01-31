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
    
    // MARK: Identifier
    
    static let identifier = "FavoriteStockListTableViewCell"
    
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
    
    // MARK: UIComponents
    
    private struct FavoriteStockLabelUIComponents: UIComponetsProtocol {
        let stockNameLabel = StockLabel()
        let currentPriceLabel = StockLabel()
        let prevDayDiffSignLabel = StockLabel()
        let prevDayDiffPriceLabel = StockLabel()
        let prevDayDiffRateLabel = StockLabel()
        
        func convertToArray() -> [UIView] {
            return [stockNameLabel, 
                    currentPriceLabel,
                    prevDayDiffSignLabel,
                    prevDayDiffPriceLabel, 
                    prevDayDiffRateLabel]
        }
    }
    
    private let labels = FavoriteStockLabelUIComponents()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout

extension FavoriteStockListTableViewCell: LayoutProtocol {
    
    private typealias SubViews = (stackView: UIStackView, labels: FavoriteStockLabelUIComponents)
    
    func layout() {
        let subViews: SubViews = (UIStackView(), labels)
        attributes(subViews)
        addSubViews(subViews)
        constraints(subViews)
    }
    
    // MARK: Attributes
    
    private func attributes(_ views: SubViews) {
        setCellAttributes()
        
        setStackViewAttributes(for: views.stackView)
        
        views.labels.stockNameLabel.setAttributes(attr: FavoriteStockNameLabelAttributes())
        views.labels.currentPriceLabel.setAttributes(attr: FavoriteStockPriceLabelAttributes())
        views.labels.prevDayDiffRateLabel.setAttributes(attr: FavoriteStockRateLabelAttributes())
        views.labels.prevDayDiffSignLabel.setAttributes(attr: FavoriteStockPriceLabelAttributes())
        views.labels.prevDayDiffPriceLabel.setAttributes(attr: FavoriteStockPriceLabelAttributes())
    }
    
    private func setCellAttributes() {
        selectionStyle = .none
    }
    
    private func setStackViewAttributes(for stackView: UIStackView) {
        stackView.axis = .horizontal
        stackView.spacing = Metric.stackViewSpacing
    }
    
    // MARK: Add Subviews
    
    private func addSubViews(_ subViews: SubViews) {
        contentView.addSubview(subViews.stackView)
        subViews.labels.convertToArray().forEach {
            subViews.stackView.addArrangedSubview($0)
        }
    }
    
    // MARK: Constraints
    
    private func constraints(_ views: SubViews) {
        setStackViewContraints(for: views.stackView)
        setFavoriteStockLabelConstraint(for: views.labels)
    }
    
    private func setStackViewContraints(for stackView: UIStackView) {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Metric.stackViewInset)
            $0.height.equalTo(Metric.stackViewHeight)
        }
    }
    
    private func setFavoriteStockLabelConstraint(for labels: FavoriteStockLabelUIComponents) {
        setLabelConstraint(for: labels.currentPriceLabel, 
                           constraint: Metric.currentPriceLabelWidth)
        setLabelConstraint(for: labels.prevDayDiffRateLabel, 
                           constraint: Metric.prevDayDiffRateLabelWidth)
        setLabelConstraint(for: labels.prevDayDiffSignLabel, 
                           constraint: Metric.prevDayDiffSignLabelWidth)
        setLabelConstraint(for: labels.prevDayDiffPriceLabel, 
                           constraint: Metric.prevDayDiffPriceLabelWidth)
    }
    
    private func setLabelConstraint(for label: UILabel, constraint width: CGFloat) {
        label.snp.makeConstraints {
            $0.width.equalTo(width)
        }
    }
}

// MARK: Public Methods

extension FavoriteStockListTableViewCell {

    func stock(_ stock: Stock?) {
        guard let stock = stock else { return }
        updateStockLabelsText(with: stock)
    }
}

// MARK: Private Methods

extension FavoriteStockListTableViewCell {
    
    private func updateStockLabelsText(with stock: Stock) {
        labels.stockNameLabel.updateStockData(with: stock.stockName)
        labels.currentPriceLabel.updateStockData(with: stock.currentPrice)
        labels.prevDayDiffPriceLabel.updateStockData(with: stock.prevDayDiffPrice)
        labels.prevDayDiffRateLabel.updateStockData(with: stock.prevDayDiffRate)
        labels.prevDayDiffSignLabel.updateStockData(with: stock.prevDayDiffSign.mark())
        
        labels.convertToArray().forEach { label in
            guard let stockLabel = label as? StockLabel else { return }
            stockLabel.updateTextColor(with: stock.prevDayDiffSign)
        }
    }
}
