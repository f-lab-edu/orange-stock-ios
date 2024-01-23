//
//  SettingViewController.swift
//  orange-stock-ios
//
//  Created by hogang on 2023/12/11.
//

import UIKit

/// ViewController: 설정 화면
final class SettingViewController: UIViewController {
    
    // MARK: Enum
    
    /// navigation
    private enum Attributes {
        static let title = "설정"
    }
    
    /// Cell Identifier
    private enum CellID {
        static let settingCell = "SettingTableViewCell"
    }
    
    // MARK: Properties
    
    private let viewModel = SettingViewModel()
    
    // MARK: UIComponents
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellID.settingCell)
        return tableView
    }()

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        bindViewModel()
    }
}

// MARK: - Layout

extension SettingViewController {
    
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
            withIdentifier: CellID.settingCell,
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
