//
//  AddFavoriteStockTableViewCell.swift
//  orange-stock-ios
//
//  Created by hogang on 2023/11/21.
//

import UIKit
import SnapKit

// View: 관심 주식 목록 하단의 관심 주식 추가하기 Cell

class AddFavoriteStockTableViewCell: UITableViewCell {
    
    private let button = UIButton()
    
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

private extension AddFavoriteStockTableViewCell {
    
    func setSubViews() {
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.setTitle("추가하기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14.0)
        button.setTitleColor(.black, for: .normal)
        button.tintColor = .black
        button.contentHorizontalAlignment = .center
        button.layer.cornerRadius = 8.0
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.black.cgColor
    }
    
    func layout() {
        contentView.addSubview(button)
        button.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
            $0.height.equalTo(44.0)
        }
    }
}
