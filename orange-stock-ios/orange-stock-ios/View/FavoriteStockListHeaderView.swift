//
//  FavoriteStockListHeaderView.swift
//  orange-stock-ios
//
//  Created by hogang on 2023/11/20.
//

import UIKit
import SnapKit

class FavoriteStockListHeaderView: UITableViewHeaderFooterView {
    private let stackView = UIStackView()
    private let stockNameLabel = UILabel() // 종목명
    private let currentPriceSortButton = UIButton() // 현재가
    private let prevDayDiffSortButton = UIButton() // 등락
    private let prevDayDiffRateSortButton = UIButton() // 등락률
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setSubViews()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension FavoriteStockListHeaderView {
    func setSubViews() {
        stackView.axis = .horizontal
        stackView.spacing = 4.0
        
        stockNameLabel.text = "종목명"
        stockNameLabel.font = .systemFont(ofSize: 14.0)
        
        currentPriceSortButton.setTitle("현재가", for: .normal)
        currentPriceSortButton.setTitleColor(.black, for: .normal)
        currentPriceSortButton.titleLabel?.font = .systemFont(ofSize: 14.0)
        currentPriceSortButton.setImage(UIImage(systemName:"chevron.up.chevron.down"), for: .normal)
        currentPriceSortButton.semanticContentAttribute = .forceRightToLeft
        currentPriceSortButton.tintColor = .black
        
        prevDayDiffSortButton.setTitle("등락", for: .normal)
        prevDayDiffSortButton.setTitleColor(.black, for: .normal)
        prevDayDiffSortButton.titleLabel?.font = .systemFont(ofSize: 14.0)
        prevDayDiffSortButton.setImage(UIImage(systemName:"chevron.up.chevron.down"), for: .normal)
        prevDayDiffSortButton.semanticContentAttribute = .forceRightToLeft
        prevDayDiffSortButton.tintColor = .black
        
        prevDayDiffRateSortButton.setTitle("등락률", for: .normal)
        prevDayDiffRateSortButton.setTitleColor(.black, for: .normal)
        prevDayDiffRateSortButton.titleLabel?.font = .systemFont(ofSize: 14.0)
        prevDayDiffRateSortButton.setImage(UIImage(systemName:"chevron.up.chevron.down"), for: .normal)
        prevDayDiffRateSortButton.semanticContentAttribute = .forceRightToLeft
        prevDayDiffRateSortButton.tintColor = .black
        prevDayDiffRateSortButton.contentHorizontalAlignment = .right
    }
    
    func layout() {
        contentView.addSubview(stackView)
        [
            stockNameLabel,
            currentPriceSortButton,
            prevDayDiffSortButton,
            prevDayDiffRateSortButton
        ].forEach {
            stackView.addArrangedSubview($0)
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10.0)
        }
        
        prevDayDiffRateSortButton.snp.makeConstraints {
            $0.width.equalTo(60.0)
        }
        prevDayDiffSortButton.snp.makeConstraints {
            $0.width.equalTo(60.0)
        }
        currentPriceSortButton.snp.makeConstraints {
            $0.width.equalTo(100.0)
        }
    }
}

