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

/// 설정 뷰컨트롤러에서 사용할 테이블 뷰
protocol SettingBaseTableViewProtocol {
    var cellIdentifier: String { get }
    var tableView: UITableView { get }
    
    func layout()
    func setNavigationItem() -> NaivationViewItems
}

extension SettingBaseTableViewProtocol where Self: UIViewController {
    
    var cellIdentifier: String {
        return "SettingBaseTableViewCell"
    }
    
    func layout() {
        navigation(item: setNavigationItem())
        attributes()
    }
    
    // MARK: Navigation
    
    private func navigation(item: NaivationViewItems) {
        navigationItem.largeTitleDisplayMode = .never
        title = item.title
    }
    
    // MARK: Attribute
    
    private func attributes() {
        view.addSubview(tableView)
        view.backgroundColor = .settingBackground
    }
}

// MARK: - Struct
/// NavigationItem
struct NaivationViewItems {
    var title: String?
    var leftBarButtonItems: [NavigationBarButtonItemProtocol]?
    var rightBarButtonItems: [NavigationBarButtonItemProtocol]?
}
