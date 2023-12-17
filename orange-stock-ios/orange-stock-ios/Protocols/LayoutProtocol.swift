//
//  LayoutProtocol.swift
//  orange-stock-ios
//
//  Created by hogang on 2023/12/17.
//

import Foundation

/// Protocol: 레이아웃 구성
protocol LayoutProtocol {
    
    // MARK: required
    
    func layout()
    
    // MARK: - optional
    
    func setNavigation()
    func attributes()
    func constraints()
    /// tableViewCell register
    func register()
}

extension LayoutProtocol {
    func setNavigation() {}
    func attributes() {}
    func constraints() {}
    func register() {}
}
