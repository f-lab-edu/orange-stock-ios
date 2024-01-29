//
//  FavoriteStockListViewController.swift
//  orange-stock-ios
//
//  Created by hogang on 2023/11/20.
//

import UIKit
import SnapKit

/// View: 나의 관심 주식 목록

final class FavoriteStockListViewController: UITableViewController {
    
    // MARK: Properties
    
    private var favoriteStockList: [Stock] = []
    
    // MARK: Enum
    
    /// navigation
    private enum Attributes {
        static let title = "관심 주식 목록"
    }
    
    /// Navigation UIBarButtonItemType
    private enum BarButtonType {
        case search
        case setting
        
        var image: UIImage? {
            switch self {
            case .search:
                return UIImage(systemName: "magnifyingglass")
            case .setting:
                return UIImage(systemName: "gearshape.fill")
            }
        }
        
        var action: Selector {
            switch self {
            case .search:
                return #selector(touchSearchBarButton)
            case .setting:
                return #selector(touchSettingBarButton)
            }
        }
    }
    
    /// Cell Identifier
    private enum CellID {
        static let stockListTableViewCell = "FavoriteStockListTableViewCell"
        static let additionTableViewCell = "FavoriteStockAdditionTableViewCell"
        static let stockListHeaderView = "FavoriteStockListHeaderView"
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        verifyLoginStatus()
        layout()
    }
    
    // MARK: Actions
    
    @objc func touchSearchBarButton() {
    }
    
    @objc func touchSettingBarButton() {
        self.navigationController?.pushViewController(SettingViewController(), animated: true)
    }
}

// MARK: Private Methods

extension FavoriteStockListViewController {
    
    // 로그인 유효성 검사
    private func verifyLoginStatus() {
        let loginVaildator = LoginValidator(helper: AppleLoginHelper(), completion: moveToLoginViewController())
        loginVaildator.verifyLoginStatus()
    }
    
    // 로그인 되어있지 않다면 로그인 뷰 컨트롤러로 이동
    private func moveToLoginViewController() -> (Bool) -> Void {
        return { [weak self] needLogin in
            guard needLogin else { return }
            DispatchQueue.main.async {
                self?.navigationController?.setViewControllers([LoginViewController()], animated: true)
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension FavoriteStockListViewController {

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return favoriteStockList.count + 1
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = indexPath.row == favoriteStockList.count
         ? additionTableViewCellForRowAt(indexPath)
         : stockListTableViewCellForRowAt(indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: CellID.stockListHeaderView
        ) as? FavoriteStockListHeaderView ?? UIView()
        return headerView
    }
    
    private func stockListTableViewCellForRowAt(_ indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: CellID.stockListTableViewCell,
            for: indexPath
        ) as? FavoriteStockListTableViewCell {
            cell.stock(favoriteStockList[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    private func additionTableViewCellForRowAt(_ indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeueReusableCell(
            withIdentifier: CellID.additionTableViewCell,
            for: indexPath
        ) as? FavoriteStockAdditionTableViewCell ?? UITableViewCell()
    }
}
 
// MARK: - Layout

extension FavoriteStockListViewController: LayoutProtocol {
    
    func layout() {
        setNavigation()
        attributes()
    }
    
    // MARK: Navigation
    
    func setNavigation() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        title = Attributes.title
        self.navigationItem.rightBarButtonItems = makeRightBarButtonItems()
    }
    
    func makeRightBarButtonItems() -> [UIBarButtonItem] {
        [makeBarButtonItem(type: .setting), makeBarButtonItem(type: .search)]
    }
    
    private func makeBarButtonItem(type: BarButtonType) -> UIBarButtonItem {
        let barButton = UIBarButtonItem(image: type.image,
                                        style: .plain,
                                        target: self,
                                        action: type.action)
        barButton.tintColor = .basic
        return barButton
    }
    
    // MARK: SubViews
    
    func attributes() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        
        tableView.register(FavoriteStockListHeaderView.self,
                           forHeaderFooterViewReuseIdentifier: CellID.stockListHeaderView)
        tableView.register(FavoriteStockListTableViewCell.self,
                           forCellReuseIdentifier: CellID.stockListTableViewCell)
        tableView.register(FavoriteStockAdditionTableViewCell.self,
                           forCellReuseIdentifier: CellID.additionTableViewCell)
    }
}
