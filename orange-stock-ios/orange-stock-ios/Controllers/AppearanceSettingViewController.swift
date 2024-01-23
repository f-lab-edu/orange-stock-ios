//
//  AppearanceSettingViewController.swift
//  orange-stock-ios
//
//  Created by hogang on 2023/12/12.
//

import UIKit
import SnapKit

/// View: 앱 내 화면 설정
final class AppearanceSettingViewController: UIViewController {
    
    // MARK: Enum
    
    /// navigation
    private enum Attributes {
        static let title = "화면 설정"
    }
    
    /// Cell Identifier
    private enum CellID {
        static let settingCell = "AppearanceSettingTableViewCell"
    }
    
    // MARK: UIComponents
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellID.settingCell)
        return tableView
    }()
    
    // MARK: Properties
    
    private let manager = AppearanceManager()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }
}

// MARK: - Layout

extension AppearanceSettingViewController {
    
    private func layout() {
        setNavigation()
        setBackgroundColor()
        constraintTableView()
    }
    
    // MARK: Navigation
    
    private func setNavigation() {
        navigationItem.largeTitleDisplayMode = .never
        title = Attributes.title
    }
    
    // MARK: Attribute
    
    private func setBackgroundColor() {
        view.backgroundColor = .settingBackground
    }
    
    // MARK: Constraints
    
    private func constraintTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
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
        let cell = tableView.cellForRow(at: indexPath)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID.settingCell,
                                                 for: indexPath)
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
