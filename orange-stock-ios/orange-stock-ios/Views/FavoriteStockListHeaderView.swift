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

private extension FavoriteStockListHeaderView {

    func layout() {
        let stackView = makeStackView()
        contentView.addSubview(stackView)
        
        let stockNameLabel = makeStockNameLabel()
        let currentPriceSortButton = makeSortButton(title: Attributes.currentPriceSortButtonTitle)
        let prevDayDiffSortButton = makeSortButton(title: Attributes.prevDayDiffSortButtonTitle)
        let prevDayDiffRateSortButton = makeSortButton(title: Attributes.prevDayDiffRateSortButtonTitle)
        [
            stockNameLabel,
            currentPriceSortButton,
            prevDayDiffSortButton,
            prevDayDiffRateSortButton
        ].forEach {
            stackView.addArrangedSubview($0)
        }
        
        addStackViewContraints(stackView)
        addSortButton(currentPriceSortButton, contraint: Metric.currentPriceSortButtonWidth)
        addSortButton(prevDayDiffSortButton, contraint: Metric.prevDayDiffSortButtonWidth)
        addSortButton(prevDayDiffRateSortButton, contraint: Metric.prevDayDiffRateSortButtonWidth)
    }
    
    // MARK: UIComponets
    
    func makeStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Metric.stackViewSpacing
        return stackView
    }
    
    func makeStockNameLabel() -> UILabel {
        let label = UILabel()
        label.text = Attributes.stockNameLabelText
        label.textColor = .basic
        label.font = .titleLabel
        return label
    }
    
    func makeSortButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.basic, for: .normal)
        button.titleLabel?.font = .titleLabel
        button.semanticContentAttribute = .forceRightToLeft
        
        button.setImage(UIImage(systemName:Attributes.sortButtonImage), for: .normal)
        button.tintColor = .basic
        return button
    }
    
    // MARK: Contraints
    
    func addStackViewContraints(_ stackView: UIStackView) {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Metric.stackViewInset)
            $0.height.equalTo(Metric.stackViewHeight)
        }
    }
    
    func addSortButton(_ button: UIButton, contraint width: CGFloat) {
        button.snp.makeConstraints {
            $0.width.equalTo(width)
        }
    }
}
