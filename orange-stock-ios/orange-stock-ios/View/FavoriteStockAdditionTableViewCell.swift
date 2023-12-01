//
//  FavoriteStockAdditionTableViewCell.swift
//  orange-stock-ios
//
//  Created by hogang on 2023/11/21.
//

import UIKit
import SnapKit

/// View: 관심 주식 목록 하단의 관심 주식 추가하기 Cell

final class FavoriteStockAdditionTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Layout

private extension FavoriteStockAdditionTableViewCell {
    
    private enum Metric {
        static let additionButtonInset = 20.0
        static let additionButtonHeight = 44.0
        static let additionButtonCornerRadius = 8.0
        static let additionButtonBorderWidth = 1.0
    }
    
    private enum Title {
        static let additionButtonTitle = "추가하기"
    }
    
    private enum SystemImage {
        static let additionButtonImage = "plus"
    }
    
    func layout() {
        let additionButton = makeAdditionButton()
        contentView.addSubview(additionButton)
        addAdditionButtonContraint(additionButton)
    }
    
    func addAdditionButtonContraint(_ button: UIButton) {
        button.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Metric.additionButtonInset)
            $0.height.equalTo(Metric.additionButtonHeight)
        }
    }
    
    func makeAdditionButton() -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(systemName: SystemImage.additionButtonImage), for: .normal)
        button.tintColor = .basic
        
        button.setTitle(Title.additionButtonTitle, for: .normal)
        button.titleLabel?.font = .titleLabel
        button.setTitleColor(.basic, for: .normal)
        button.contentHorizontalAlignment = .center
        
        button.layer.cornerRadius = Metric.additionButtonCornerRadius
        button.layer.borderWidth = Metric.additionButtonBorderWidth
        button.layer.borderColor = UIColor.basic.cgColor
        return button
    }
}
