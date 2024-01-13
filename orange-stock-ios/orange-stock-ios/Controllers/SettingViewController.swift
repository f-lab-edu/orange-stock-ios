//
//  SettingViewController.swift
//  orange-stock-ios
//
//  Created by hogang on 2023/12/11.
//

import UIKit

/// View: 설정
final class SettingViewController: UIViewController {
    
    // MARK: Properties
    
    private let tableView = UITableView(frame: .zero,
                                        style: .insetGrouped)
    private let viewModel = SettingViewModel()
    
    /// navigation
    private enum Attributes {
        static let title = "설정"
    }
    
    /// Cell Identifier
    private enum CellID {
        static let settingCell = "SettingTableViewCell"
    }

    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        bindViewModel()
    }
}

// MARK: - Bind

extension SettingViewController {
    private func bindViewModel() {
        bindPushViewController()
        bindShowLogoutAlert()
    }
    
    private func bindPushViewController() {
        viewModel.pushViewController.bind { [weak self] type in
            guard let controller = self?.getPushViewController(type) else { return }
            DispatchQueue.main.async {
                self?.pushViewController(controller)
            }
        }
    }
    
    private func bindShowLogoutAlert() {
        viewModel.showLogoutAlert.bind { [weak self] isShow in
            if isShow {
                DispatchQueue.main.async {
                    self?.showLogoutAlert()
                }
            }
        }
    }
    
    private func getPushViewController(_ type: PushViewControllerType?) -> UIViewController? {
        switch type {
        case .AppearanceSettingViewController:
            return AppearanceSettingViewController()
        case .none:
            return nil
        }
    }
}

// MARK: - UITableViewDataSource

extension SettingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CellID.settingCell,
            for: indexPath
        )
        tableViewCell(cell, rowType: viewModel.rowType(at: indexPath))
        return cell
    }
    
    private func tableViewCell(_ cell: UITableViewCell,
                               rowType: TableViewCellRowProtocol?) {
        cell.selectionStyle = .none
        cell.textLabel?.text = rowType?.title
        cell.accessoryType = getTableViewAccessory(rowType?.accessory ?? .none)
    }
    private func getTableViewAccessory(_ type: TableViewCellAccessoryType) -> UITableViewCell.AccessoryType {
        switch type {
        case .none:
            return .none
        case .disclosureIndicator:
            return .disclosureIndicator
        case .checkmark:
            return .checkmark
        }
    }
}

// MARK: - UITableViewDelegate

extension SettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
    }
    
    private func showLogoutAlert() {
        let confirmAction = UIAlertAction(title: "로그아웃", style: .destructive) { [weak self] _ in
            self?.viewModel.didTouchLogout()
            // 로그인 화면으로 이동
            self?.showLoginViewController()
        }
        showAlert(title: "로그아웃 하시겠습니까?",
                  message: nil,
                  actions: [.cancel, confirmAction])
    }
}

// MARK: - Private Method

extension SettingViewController {
    
    private func pushViewController(_ pushViewController: UIViewController?) {
        guard let pushViewController = pushViewController
            else { return }
        self.navigationController?.pushViewController(pushViewController, animated: true)
    }
    
    /// 로그인 화면으로 이동
    private func showLoginViewController() {
        DispatchQueue.main.async {
            self.navigationController?.setViewControllers(
                [LoginViewController()],
                animated: true
            )
        }
    }
}

// MARK: - Layout

extension SettingViewController: LayoutProtocol {
    
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
    
    func registerTableViewCell() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellID.settingCell)
    }
}
