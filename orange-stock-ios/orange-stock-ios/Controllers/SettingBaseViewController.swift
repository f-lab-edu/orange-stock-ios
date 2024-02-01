//
//  SettingBaseViewController.swift
//  orange-stock-ios
//
//  Created by hogang on 2/1/24.
//

import UIKit

/// 설정 ViewController의 SuperClass
class SettingBaseViewController: UIViewController {
    
    // MARK: Enum
    
    let CellIdentifier = "SettingTableViewCell"
    
    // MARK: UIComponents
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier)
        return tableView
    }()

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }
    
    func setNaivationViewItems() -> NaivationViewItems { return NaivationViewItems() }
}

// MARK: - Layout

extension SettingBaseViewController: LayoutProtocol {
    
    func layout() {
        navigation(item: setNaivationViewItems())
        attributes()
        constraints()
    }
    
    // MARK: Navigation
    
    func navigation(item: NaivationViewItems) {
        navigationItem.largeTitleDisplayMode = .never
        title = item.title
    }
    
    // MARK: Attribute
    
    func attributes() {
        setBackgroundColor()
    }
    
    private func setBackgroundColor() {
        view.backgroundColor = .settingBackground
    }
    
    // MARK: Constraints
    
    func constraints() {
        constraintTableView()
    }
    
    private func constraintTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
