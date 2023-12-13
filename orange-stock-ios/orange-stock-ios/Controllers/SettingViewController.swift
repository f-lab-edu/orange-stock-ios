//
//  SettingViewController.swift
//  orange-stock-ios
//
//  Created by hogang on 2023/12/11.
//

import UIKit

/// View: 앱 내 설정
final class SettingViewController: UIViewController {
    
    // MARK: Properties
    
    private let tableView = UITableView(frame: .zero,
                                        style: .insetGrouped)
    
    // MARK: Enum
    
    /// tableView Row
    private enum SettingRow: Int, CaseIterable {
        case appearance = 0
        
        var title: String {
            switch self {
            case .appearance:
                return "화면 설정"
            }
        }
        
        var accessory: UITableViewCell.AccessoryType {
            switch self {
            case .appearance:
                return .disclosureIndicator
            }
        }
        
        var pushViewController: UIViewController {
            switch self {
            case .appearance:
                return AppearanceSettingViewController()
            }
        }
    }
    
    /// navigation
    private enum Attributes {
        static let title = "설정"
    }
    
    /// Cell Identifier
    private enum CellID {
        static let settingCell = "SettingTableViewCell"
    }

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        layout()
        register()
    }
}

// MARK: - UITableViewDataSource

extension SettingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingRow.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let settingRow = SettingRow(rawValue: indexPath.row)
        else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID.settingCell, for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = settingRow.title
        cell.accessoryType = settingRow.accessory
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let settingRow = SettingRow(rawValue: indexPath.row) else { return }
        self.navigationController?.pushViewController(settingRow.pushViewController, animated: true)
    }
}

// MARK: - Layout

private extension SettingViewController {
    
    // MARK: Navigation
    
    func setNavigation() {
        navigationItem.largeTitleDisplayMode = .never
        title = Attributes.title
    }
    
    // MARK: SubViews
    
    func layout() {
        attributes()
        constraints()
    }
    
    /// 서브뷰의 속성 설정
    func attributes() {
        view.backgroundColor = .settingBackground
        view.addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    /// 서브뷰의 constraints 설정
    func constraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func register() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellID.settingCell)
    }
}
