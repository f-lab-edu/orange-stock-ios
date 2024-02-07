//
//  FavoriteStockListViewController.swift
//  orange-stock-ios
//
//  Created by hogang on 2023/11/20.
//

import UIKit
import SnapKit

/// ViewController : 나의 관심 주식 목록
final class FavoriteStockListViewController: UITableViewController {
    
    // MARK: UIComponets
    
    /// Navigation UIBarButtonItem
    private struct SearchBarButtonItem: NavigationBarButtonItemProtocol {
        var image: UIImage? = UIImage(systemName: "magnifyingglass")
        var title: String?
        var action: Selector? = #selector(touchSearchBarButton)
    }
    
    private struct SettingBarButtonItem: NavigationBarButtonItemProtocol {
        var image: UIImage? = UIImage(systemName: "gearshape.fill")
        var title: String?
        var action: Selector? = #selector(touchSettingBarButton)
    }
    
    // MARK: Properties
    
    private var favoriteStockList: [Stock] = []
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        verifyLoginStatus()
        layout()
    }
    
    // MARK: Actions
    
    @objc func touchSearchBarButton() {}
    
    @objc func touchSettingBarButton() {
        self.navigationController?.pushViewController(SettingViewController(), animated: true)
    }
}

// MARK: - Layout

extension FavoriteStockListViewController: LayoutProtocol {
    
    func layout() {
        let naviItem = NavigationViewItems(
            title: "관심 주식 목록",
            rightBarButtonItems: [SettingBarButtonItem(), SearchBarButtonItem()]
        )
        navigation(item: naviItem)
        attributes()
    }
    
    // MARK: Navigation
    
    func navigation(item: NavigationViewItems) {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        
        title = item.title
        navigationItem.rightBarButtonItems = makeNavigationBarButtonItems(with: item.rightBarButtonItems)
    }
    
    private func makeNavigationBarButtonItems(with items: [NavigationBarButtonItemProtocol]?) -> [UIBarButtonItem]? {
        guard let items = items else { return nil }
        return items.map { makeBarButtonItem(with: $0) }
    }
    
    private func makeBarButtonItem(with item: NavigationBarButtonItemProtocol) -> UIBarButtonItem {
        let barButton = UIBarButtonItem(image: item.image,
                                        style: .plain,
                                        target: self,
                                        action: item.action)
        barButton.tintColor = .basic
        return barButton
    }
    
    // MARK: Attribute
    
    func attributes() {
        setTableViewAttributes()
    }
    
    private func setTableViewAttributes() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        
        tableView.register(FavoriteStockListHeaderView.self,
                           forHeaderFooterViewReuseIdentifier: FavoriteStockListHeaderView.identifier)
        tableView.register(FavoriteStockListTableViewCell.self,
                           forCellReuseIdentifier: FavoriteStockListTableViewCell.identifier)
        tableView.register(AdditionTableViewCell.self,
                           forCellReuseIdentifier: AdditionTableViewCell.identifier)
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
        // 마지막 cell은 추가하기 Cell
        return favoriteStockList.count + 1
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = indexPath.row == favoriteStockList.count
        ? additionTableViewCellForRowAt(indexPath)
        : stockListTableViewCellForRowAt(indexPath)
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView,
                            viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: FavoriteStockListHeaderView.identifier
        ) as? FavoriteStockListHeaderView ?? UIView()
        return headerView
    }
    
    private func stockListTableViewCellForRowAt(_ indexPath: IndexPath) -> UITableViewCell? {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: FavoriteStockListTableViewCell.identifier,
            for: indexPath
        ) as? FavoriteStockListTableViewCell
        cell?.stock(favoriteStockList[indexPath.row])
        return cell
    }
    
    private func additionTableViewCellForRowAt(_ indexPath: IndexPath) -> UITableViewCell? {
        tableView.dequeueReusableCell(
            withIdentifier: AdditionTableViewCell.identifier,
            for: indexPath
        ) as? AdditionTableViewCell
    }
}
