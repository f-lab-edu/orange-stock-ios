//
//  LayoutProtocol.swift
//  orange-stock-ios
//
//  Created by hogang on 2023/12/17.
//

import Foundation

/// ViewController Layout 구성
protocol ViewControllerLayout {
    
    // MARK: required
    
    func layout()
    func navigation()
    func attributes()
    func constraints()
}

@available(*, deprecated, message: "viewController use ViewControllerLayout instead")
/// Protocol: 레이아웃 구성
protocol LayoutProtocol {
    
    // MARK: required
    
    func layout()
    
    // MARK: - optional
    
    func setNavigation()
    func attributes()
    func constraints()
    /// tableViewCell register
    func registerTableViewCell()
}

extension LayoutProtocol {
    func setNavigation() {}
    func attributes() {}
    func constraints() {}
    func registerTableViewCell() {}
}
