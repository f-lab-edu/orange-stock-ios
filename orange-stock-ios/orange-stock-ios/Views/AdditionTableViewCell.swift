//
//  AdditionTableViewCell.swift
//  orange-stock-ios
//
//  Created by hogang on 2023/11/21.
//

import UIKit
import SnapKit

/// View:  추가하기 Cell

final class AdditionTableViewCell: UITableViewCell {
    
    static let identifier = "AdditionTableViewCell"
    
    // MARK: Enum
    
    /// Constraint
    private enum Metric {
        static let additionButtonInset = 20.0
        static let additionButtonHeight = 44.0
        static let additionButtonCornerRadius = 8.0
        static let additionButtonBorderWidth = 1.0
    }
    
    /// Attributes
    private enum Attributes {
        // button title
        static let additionButtonTitle = "추가하기"
        // button systemImage
        static let additionImage = "plus"
    }
    
    // MARK: Init
    
    let additionButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout

extension AdditionTableViewCell: LayoutProtocol {
    
    func layout() {
        attributes()
        constraints()
    }
    
    // MARK: Attribute
    
    func attributes() {
        contentView.addSubview(additionButton)
        
        additionButton.setImage(UIImage(systemName: Attributes.additionImage), for: .normal)
        additionButton.tintColor = .basic
        
        additionButton.setTitle(Attributes.additionButtonTitle, for: .normal)
        additionButton.titleLabel?.font = .titleLabel
        additionButton.setTitleColor(.basic, for: .normal)
        additionButton.contentHorizontalAlignment = .center
        
        additionButton.layer.cornerRadius = Metric.additionButtonCornerRadius
        additionButton.layer.borderWidth = Metric.additionButtonBorderWidth
        additionButton.layer.borderColor = UIColor.label.cgColor
    }
    
    // 화면 설정 모드 변경 시 버튼 테두리 색상 변경
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        additionButton.layer.borderColor = UIColor.basic.cgColor
    }
    
    // MARK: Constraints
    
    func constraints() {
        additionButton.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Metric.additionButtonInset)
            $0.height.equalTo(Metric.additionButtonHeight)
        }
    }
}
