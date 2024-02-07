//
//  SettingBaseTableViewProtocol.swift
//  orange-stock-ios
//
//  Created by hogang on 2/2/24.
//

import UIKit

// MARK: - Protocol

/// 설정 관련 레이아웃 중 테이블뷰를 사용하는 뷰컨트롤러의 레이아웃 프로토콜
protocol SettingBaseViewControllerLayoutProtocol {
    func layout(with tableViewLayout: SettingBaseTableViewLayoutProtocol)
    func setTableView(cellIdentifier: String) -> UITableView
}

extension SettingBaseViewControllerLayoutProtocol where Self: UIViewController {
    func setTableView(cellIdentifier: String) -> UITableView {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: cellIdentifier)
        return tableView
    }
}

/// 템플릿 메서드 패턴을 적용한, 설정 관련 레이아웃에서 사용하는 테이블 뷰 프로토콜
protocol SettingBaseTableViewLayoutProtocol {
    
    // 호출되어야 하는 메서드
    mutating func layout(with viewController: UIViewController)
    
    // MARK: required
    
    var tableView: UITableView { get set }
    
    func naivationViewItems() -> NavigationViewItems
    
    // MARK: optional
    
    static var cellIdentifier: String { get }
    
    func navigation(with viewController: UIViewController, item: NavigationViewItems)
    func attributes(with superView: UIView)
    func constraint(with superView: UIView, tableView: UITableView)
}

extension SettingBaseTableViewLayoutProtocol {
    
    func layout(with viewController: UIViewController) {
        tableView.delegate = viewController as? any UITableViewDelegate
        tableView.dataSource = viewController as? any UITableViewDataSource
        
        navigation(with: viewController, item: naivationViewItems())
        attributes(with: viewController.view)
        constraint(with: viewController.view, tableView: tableView)
    }
    
    static var cellIdentifier: String {
        return "SettingBaseTableViewCell"
    }
    
    func navigation(with viewController: UIViewController, item: NavigationViewItems) {
        viewController.navigationItem.largeTitleDisplayMode = .never
        viewController.title = item.title
    }
    
    func attributes(with superView: UIView) {
        superView.backgroundColor = .settingBackground
    }
    
    func constraint(with superView: UIView, tableView: UITableView) {
        superView.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(superView)
        }
    }
}

// MARK: Struct

struct SettingTableViewLayout: SettingBaseTableViewLayoutProtocol {
    
    var tableView: UITableView
    
    func naivationViewItems() -> NavigationViewItems {
        NavigationViewItems(title: "설정")
    }
}

struct AppearanceSettingTableViewLayout: SettingBaseTableViewLayoutProtocol {
    
    var tableView: UITableView
    
    func naivationViewItems() -> NavigationViewItems {
        NavigationViewItems(title: "화면 설정")
    }
}
