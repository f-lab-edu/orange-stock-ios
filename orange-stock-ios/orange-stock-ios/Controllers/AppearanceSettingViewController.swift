//
//  AppearanceSettingViewController.swift
//  orange-stock-ios
//
//  Created by hogang on 2023/12/12.
//

import UIKit
import SnapKit

/// View: 앱 내 화면 설정 (라이트모드, 다크모드)
final class AppearanceSettingViewController: UIViewController {
    
    // MARK: Properties
    
    private let tableView = UITableView(frame: .zero,
                                        style: .insetGrouped)
    
    // MARK: Enum
    
    /// navigation
    private enum Attributes {
        static let title = "화면 설정"
    }
    
    /// Cell Identifier
    private enum CellID {
        static let settingCell = "AppearanceSettingTableViewCell"
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

extension AppearanceSettingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppearanceSetting.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let appearanceSetting = AppearanceSetting(rawValue: indexPath.row)
        else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID.settingCell, for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = appearanceSetting.title
        if AppearanceManager.shared.appearanceSetting == appearanceSetting {
            cell.accessoryType = .checkmark
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension AppearanceSettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let appearanceSetting = AppearanceSetting(rawValue: indexPath.row) else { return }
        
        // 선택한 셀로 checkmark 이동
        let oldIndexPath = IndexPath(row: AppearanceManager.shared.appearanceSetting.rawValue, section: 0)
        moveCheckMark(from: oldIndexPath, to: indexPath)
        
        // 화면설정 매니저에 변경된 값 전달
        AppearanceManager.shared.appearanceSetting = appearanceSetting
    }
    
    private func moveCheckMark(from oldIndexPath:IndexPath,
                                 to selectedIndexPath: IndexPath) {
        let oldCell = tableView.cellForRow(at: oldIndexPath)
        let selectedCell = tableView.cellForRow(at: selectedIndexPath)
        
        oldCell?.accessoryType = .none
        selectedCell?.accessoryType = .checkmark
    }
}

// MARK: - Layout

private extension AppearanceSettingViewController {
    
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
    
    /// talbeViewCell Register
    func register() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellID.settingCell)
    }
}
