//
//  FavoriteStockListTableViewCell.swift
//  orange-stock-ios
//
//  Created by hogang on 2023/11/20.
//

import UIKit
import SnapKit

// View: 관심 주식 목록의 종목 Cell

class FavoriteStockListTableViewCell: UITableViewCell {
    
    private let stackView = UIStackView()
    private let stockNameLabel = UILabel() // 종목명
    private let currentPriceLabel = UILabel() // 현재가
    private let prevDayDiffSignLabel = UILabel() // 등락 기호 ▲ / ▼
    private let prevDayDiffLabel = UILabel() // 등락
    private let prevDayDiffRateLabel = UILabel() // 등락률
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setSubViews()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Layout

private extension FavoriteStockListTableViewCell {
    
    func setSubViews() {
        stackView.axis = .horizontal
        stackView.spacing = 4.0
        
        stockNameLabel.text = "삼성전자"
        stockNameLabel.font = .systemFont(ofSize: 14.0)
        
        currentPriceLabel.text = "72,500"
        currentPriceLabel.textAlignment = .right
        currentPriceLabel.font = .systemFont(ofSize: 14.0)
        
        prevDayDiffSignLabel.text = "▲"
        currentPriceLabel.textAlignment = .right
        prevDayDiffSignLabel.font = .systemFont(ofSize: 14.0)
        
        prevDayDiffLabel.text = "600"
        prevDayDiffLabel.textAlignment = .right
        prevDayDiffLabel.font = .systemFont(ofSize: 14.0)
        
        prevDayDiffRateLabel.text = "0.25%"
        prevDayDiffRateLabel.textAlignment = .right
        prevDayDiffRateLabel.font = .systemFont(ofSize: 14.0)
    }
    
    func layout() {
        contentView.addSubview(stackView)
        
        let spacingView = UIView()
        [
            stockNameLabel,
            currentPriceLabel,
            spacingView,
            prevDayDiffSignLabel,
            prevDayDiffLabel,
            prevDayDiffRateLabel
        ].forEach {
            stackView.addArrangedSubview($0)
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10.0)
            $0.height.equalTo(30.0)
        }
        
        prevDayDiffRateLabel.snp.makeConstraints {
            $0.width.equalTo(60.0)
        }
        prevDayDiffLabel.snp.makeConstraints {
            $0.width.equalTo(44.0)
        }
        prevDayDiffSignLabel.snp.makeConstraints {
            $0.width.equalTo(14.0)
        }
        spacingView.snp.makeConstraints {
            $0.width.equalTo(16.0)
        }
        currentPriceLabel.snp.makeConstraints {
            $0.width.equalTo(100.0)
        }
    }
}
