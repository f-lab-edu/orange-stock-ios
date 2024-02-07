//
//  FavoriteStockListHeaderView.swift
//  orange-stock-ios
//
//  Created by hogang on 2023/11/20.
//

import UIKit
import SnapKit

/// View: 관심 주식 목록의 제목 행 (종목명, 현재가, 등락, 등락률)
final class FavoriteStockListHeaderView: UITableViewHeaderFooterView {
    
    // MARK: identifier
    
    static let identifier = "FavoriteStockListHeaderView"
    
    // MARK: Enum - Attributes
    
    /// Constraint
    enum Metric {
        static let stackViewSpacing = 4.0
        static let stackViewInset = 10.0
        static let stackViewHeight = 30.0
        static let currentPriceSortButtonWidth = 100.0
        static let prevDayDiffSortButtonWidth = 64.0
        static let prevDayDiffRateSortButtonWidth = 60.0
    }
    
    /// Attributes
    enum Attributes {
        static let stockNameLabelText = "종목명"
        static let currentPriceSortButtonTitle = "현재가"
        static let prevDayDiffSortButtonTitle = "등락"
        static let prevDayDiffRateSortButtonTitle = "등락률"
        
        // button systemImage
        static let sortButtonImage = "chevron.up.chevron.down"
    }
    
    // MARK: UIComponents
    
    private struct FavoriteStockListHeaderViewUIComponents: UIComponetsProtocol {
        let stackView = UIStackView()
        let stockNameLabel = UILabel()
        let currentPriceSortButton = UIButton()
        let prevDayDiffSortButton = UIButton()
        let prevDayDiffRateSortButton = UIButton()
        
        func convertToArray() -> [UIView] {
            return [
                stockNameLabel,
                currentPriceSortButton,
                prevDayDiffSortButton,
                prevDayDiffRateSortButton
            ]
        }
    }
    
    // MARK: - Init
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout

extension FavoriteStockListHeaderView: LayoutProtocol {
    
    private typealias SubViews = FavoriteStockListHeaderViewUIComponents
    
    func layout() {
        let subViews = FavoriteStockListHeaderViewUIComponents()
        attributes(subViews)
        addSubViews(subViews)
        constraints(subViews)
    }
    
    // MARK: Attributes
    
    private func attributes(_ views: SubViews) {
        setStackViewAttribute(for: views.stackView)
        setStockNameLabelAttribute(for: views.stockNameLabel)
        setSortButtonAttribute(for: views.currentPriceSortButton, title: Attributes.currentPriceSortButtonTitle)
        setSortButtonAttribute(for: views.prevDayDiffSortButton, title: Attributes.prevDayDiffSortButtonTitle)
        setSortButtonAttribute(for: views.prevDayDiffRateSortButton, title: Attributes.prevDayDiffRateSortButtonTitle)
    }
    
    private func setStackViewAttribute(for stackView: UIStackView) {
        stackView.axis = .horizontal
        stackView.spacing = Metric.stackViewSpacing
    }
    
    private func setStockNameLabelAttribute(for label: UILabel) {
        label.text = Attributes.stockNameLabelText
        label.textColor = .basic
        label.font = .titleLabel
    }
    
    private func setSortButtonAttribute(for button: UIButton, title: String) {
        button.setTitleColor(.basic, for: .normal)
        button.titleLabel?.font = .titleLabel
        button.tintColor = .basic
        button.semanticContentAttribute = .forceRightToLeft
        
        button.setTitle(title, for: .normal)
        button.setImage(UIImage(systemName: Attributes.sortButtonImage), for: .normal)
    }
    
    // MARK: Add SubViews
    
    private func addSubViews(_ views: SubViews) {
        addSubview(views.stackView)
        views.convertToArray().forEach {
            views.stackView.addArrangedSubview($0)
        }
    }
    
    // MARK: Contraints
    
    private func constraints(_ views: SubViews) {
        setStackViewContraints(views.stackView)
        setSortButtonConstraints(views.currentPriceSortButton,
                                 contraint: Metric.currentPriceSortButtonWidth)
        setSortButtonConstraints(views.prevDayDiffSortButton,
                                 contraint: Metric.prevDayDiffSortButtonWidth)
        setSortButtonConstraints(views.prevDayDiffRateSortButton,
                                 contraint: Metric.prevDayDiffRateSortButtonWidth)
    
    }
    
    private func setStackViewContraints(_ stackView: UIStackView) {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Metric.stackViewInset)
            $0.height.equalTo(Metric.stackViewHeight)
        }
    }
    
    private func setSortButtonConstraints(_ button: UIButton, contraint width: CGFloat) {
        button.snp.makeConstraints {
            $0.width.equalTo(width)
        }
    }
}
