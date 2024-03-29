//
//  SettingViewController.swift
//  orange-stock-ios
//
//  Created by hogang on 2023/12/11.
//

import UIKit

/// ViewController: 설정 화면
final class SettingViewController: UIViewController {
    
    // MARK: Properties
    
    private let viewModel = SettingViewModel()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout(with: getSettingTableViewLayout())
        bindViewModel()
    }
}

// MARK: - LayoutProtocol

extension SettingViewController: SettingBaseViewControllerLayoutProtocol {
    
    func layout(with tableView: SettingBaseTableViewLayoutProtocol) {
        tableView.layout(with: self)
    }
}

// MARK: - Bind

extension SettingViewController {
    
    private func bindViewModel() {
        bindPushViewController()
        bindShowLogoutAlert()
    }
    
    private func bindPushViewController() {
        viewModel.pushViewController.bind { [weak self] controller in
            DispatchQueue.main.async {
                self?.pushViewController(controller)
            }
        }
    }
    
    private func bindShowLogoutAlert() {
        viewModel.showLogoutAlert.bind { [weak self] isShow in
            guard isShow else { return }
            DispatchQueue.main.async {
                    self?.showLogoutAlert()
            }
        }
    }
}

// MARK: - Private Method

extension SettingViewController {
    
    func getSettingTableViewLayout() -> SettingBaseTableViewLayoutProtocol {
        return SettingTableViewLayout(
            tableView: setTableView(cellIdentifier: SettingTableViewLayout.cellIdentifier)
        )
    }
    
    private func pushViewController(_ pushViewController: UIViewController?) {
        guard let controller = pushViewController else { return }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // 로그인 화면으로 이동
    private func showLoginViewController() {
        DispatchQueue.main.async {
            self.navigationController?.setViewControllers(
                [LoginViewController()],
                animated: true
            )
        }
    }
    
    // 로그아웃 Alert 보여주기
    private func showLogoutAlert() {
        let logoutAction = UIAlertAction(title: "로그아웃",
                                          style: .destructive,
                                          handler: logoutAlertAction())
        showAlert(title: "로그아웃 하시겠습니까?",
                  message: nil,
                  actions: [.cancel, logoutAction])
    }
    
    private func logoutAlertAction() -> ((UIAlertAction) -> Void)? {
        return {  [weak self] _ in
            self?.viewModel.didTouchLogout()
            // 로그인 화면으로 이동
            self?.showLoginViewController()
        }
    }
    
    // TableViewCell 속성 설정
    private func configTableViewCell(_ cell: UITableViewCell, rowInfo: SettingTableViewRow) {
        cell.selectionStyle = .none
        cell.textLabel?.text = rowInfo.title
        cell.accessoryType = rowInfo.accessory
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
            withIdentifier: SettingTableViewLayout.cellIdentifier,
            for: indexPath
        )
        let rowInfo: SettingTableViewRow = viewModel.cellForRowAt(indexPath)
        
        configTableViewCell(cell, rowInfo: rowInfo)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SettingViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
    }
}
