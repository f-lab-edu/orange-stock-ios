//
//  LayoutProtocol.swift
//  orange-stock-ios
//
//  Created by hogang on 2023/12/17.
//

import UIKit

// MARK: - Protocol
/// Layout 구성
protocol LayoutProtocol {
    
    // required
    func layout()
    
    // optional
    func navigation(item: NaivationViewItems)
    func attributes()
    func constraints()
}

// MARK: Optional

extension LayoutProtocol {
    func navigation(item: NaivationViewItems) {}
    func attributes() {}
    func constraints() {}
}

/// SubViews UIComponents
protocol UIComponetsProtocol {
    func convertToArray() -> [UIView]
}

/// Navigtaion
protocol NavigationBarButtonItemProtocol {
    var image: UIImage? { get }
    var title: String? { get }
    var action: Selector? { get }
}

// MARK: - Struct
/// NavigationItem
struct NaivationViewItems {
    var title: String?
    var leftBarButtonItems: [NavigationBarButtonItemProtocol]?
    var rightBarButtonItems: [NavigationBarButtonItemProtocol]?
}
