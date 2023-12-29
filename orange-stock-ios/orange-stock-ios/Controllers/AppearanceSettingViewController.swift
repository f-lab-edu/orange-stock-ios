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
        layout()
    }
}

// MARK: - UITableViewDataSource

extension AppearanceSettingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppearanceSetting.allCases.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID.settingCell,
                                                 for: indexPath)
        if let appearanceSetting = AppearanceSetting(rawValue: indexPath.row) {
            cell.selectionStyle = .none
            cell.textLabel?.text = appearanceSetting.title
            cell.accessoryType = showCheckMark(appearanceSetting) ? .checkmark : .none
        }
        return cell
    }
    
    /// 테이블뷰 셀에 checkmark를 보여줘야 하는지 판별
    private func showCheckMark(_ appearanceSetting: AppearanceSetting) -> Bool {
        return AppearanceManager.shared.appearanceSetting == appearanceSetting
    }
}

// MARK: - UITableViewDelegate

extension AppearanceSettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let appearanceSetting = AppearanceSetting(rawValue: indexPath.row) else { return }
        
        // 선택한 셀로 checkmark 이동
        let oldIndexPath = IndexPath(row: AppearanceManager.shared.appearanceSetting.rawValue,
                                     section: 0)
        moveCheckMark(from: oldIndexPath, to: indexPath)
        
        // 화면설정 매니저에 변경된 값 전달
        AppearanceManager.shared.appearanceSetting = appearanceSetting
    }
    
    /// 이 전 Cell의 checkmark를 없애고 사용자가 select한 Cell에 checkmark  표시
    private func moveCheckMark(from oldIndexPath:IndexPath,
                                 to selectedIndexPath: IndexPath) {
        let oldCell = tableView.cellForRow(at: oldIndexPath)
        let selectedCell = tableView.cellForRow(at: selectedIndexPath)
        oldCell?.accessoryType = .none
        selectedCell?.accessoryType = .checkmark
    }
}

// MARK: - Layout

extension AppearanceSettingViewController: LayoutProtocol {
    
    func layout() {
        setNavigation()
        attributes()
        constraints()
        registerTableViewCell()
    }
    
    // MARK: Navigation
    
    func setNavigation() {
        navigationItem.largeTitleDisplayMode = .never
        title = Attributes.title
    }
    
    // MARK: SubViews
    
    /// 서브뷰의 속성 설정
    func attributes() {
        setAttribute(view: view)
        setAttribute(tableView: tableView)
    }
    
    func setAttribute(view: UIView) {
        view.backgroundColor = .settingBackground
        view.addSubview(tableView)
    }
    
    func setAttribute(tableView: UITableView) {
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
    func registerTableViewCell() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellID.settingCell)
    }
}
