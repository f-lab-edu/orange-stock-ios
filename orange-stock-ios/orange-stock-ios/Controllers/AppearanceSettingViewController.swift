//
//  AppearanceSettingViewController.swift
//  orange-stock-ios
//
//  Created by hogang on 2023/12/12.
//

import UIKit
import SnapKit

/// ViewController: 앱 내 화면 설정
final class AppearanceSettingViewController: UIViewController {
    
    // MARK: Properties
    
    private let manager = AppearanceManager()
    private lazy var tableViewLayout: SettingBaseTableViewLayoutProtocol = {
        return AppearanceSettingTableViewLayout(
            tableView: self.setTableView(
                cellIdentifier: AppearanceSettingTableViewLayout.cellIdentifier
            )
        )
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout(with: tableViewLayout)
    }
}

// MARK: - SettingViewControllerLayoutProtocol

extension AppearanceSettingViewController: SettingBaseViewControllerLayoutProtocol {
    
    func layout(with tableViewLayout: SettingBaseTableViewLayoutProtocol) {
        tableViewLayout.layout(with: self)
    }
}

// MARK: Private Methods

extension AppearanceSettingViewController {
    
    // 테이블뷰 셀에 checkmark를 보여줘야 하는지 판별
    private func showCheckMark(with type: AppearanceType) -> Bool {
        return manager.appearanceType() == type
    }
    
    // 이 전 cell의 checkmark를 없애고 사용자가 select한 Cell에 checkmark  표시
    private func moveCheckMark(from oldIndexPath: IndexPath,
                               to selectedIndexPath: IndexPath) {
        indexPath(oldIndexPath, accessory: .none)
        indexPath(selectedIndexPath, accessory: .checkmark)
    }
    
    private func indexPath(_ indexPath: IndexPath,
                           accessory accessoryType: UITableViewCell.AccessoryType) {
        let cell = tableViewLayout.tableView.cellForRow(at: indexPath)
        cell?.accessoryType = accessoryType
    }
    
    // tableViewCell 속성 설정
    private func configTableViewCell(_ cell: UITableViewCell, appearanceType: AppearanceType) {
        let appearanceSetting = appearanceType.appearanceSetting
        cell.selectionStyle = .none
        cell.textLabel?.text = appearanceSetting.title
        cell.accessoryType = showCheckMark(with: appearanceSetting.appearanceType) ? .checkmark : .none
    }
}

// MARK: - UITableViewDataSource

extension AppearanceSettingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppearanceType.allCases.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: AppearanceSettingTableViewLayout.cellIdentifier,
            for: indexPath
        )
        if let appearanceType = AppearanceType(rawValue: indexPath.row) {
            configTableViewCell(cell, appearanceType: appearanceType)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension AppearanceSettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 선택한 셀로 checkmark 이동
        let oldIndexPath = IndexPath(row: manager.appearanceType().rawValue, section: 0)
        moveCheckMark(from: oldIndexPath, to: indexPath)
        
        // 화면설정 매니저에 변경된 값 전달
        if let appearanceSetting = AppearanceType(rawValue: indexPath.row)?.appearanceSetting {
            manager.setAppearanceSetting(appearanceSetting)
        }
    }
}
