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
        static let searchImage = "magnifyingglass"
        static let settingImage = "gearshape.fill"
    }
    
    /// Cell Identifier
    private enum CellID {
        static let stockListTableViewCell = "FavoriteStockListTableViewCell"
        static let additionTableViewCell = "FavoriteStockAdditionTableViewCell"
        static let stockListHeaderView = "FavoriteStockListHeaderView"
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }
    
    // MARK: - Actions
    
    @objc func touchSearchBarButton() {
    }
    
    @objc func touchSettingBarButton() {
        self.navigationController?.pushViewController(SettingViewController(), animated: true)
    }
}

// MARK: - UITableViewDataSource

extension FavoriteStockListViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteStockList.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = indexPath.row == favoriteStockList.count
         ? additionTableViewCellForRowAt(indexPath)
         : stockListTableViewCellForRowAt(indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CellID.stockListHeaderView)
         as? FavoriteStockListHeaderView ?? UIView()
        return headerView
    }
    
    private func stockListTableViewCellForRowAt(_ indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellID.stockListTableViewCell,
                                                       for: indexPath) as? FavoriteStockListTableViewCell {
            cell.stock(favoriteStockList[indexPath.row])
            return cell
        }
        else {
            return UITableViewCell()
        }
    }
    
    private func additionTableViewCellForRowAt(_ indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: CellID.additionTableViewCell,
                                             for: indexPath) as? FavoriteStockAdditionTableViewCell
         ?? UITableViewCell()
    }
}
 
// MARK: - Layout

extension FavoriteStockListViewController: LayoutProtocol {
    
    func layout() {
        setNavigation()
        attributes()
        register()
    }
    
    // MARK: Navigation
    
    func setNavigation() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        title = Attributes.title
        self.navigationItem.rightBarButtonItems = makeRightBarButtonItems()
    }
    
    func makeRightBarButtonItems() -> [UIBarButtonItem] {
        let searchBarButton = makeSearchBarButtonItem()
        let settingBarButton = makeSettingBarButtonItem()
        return [settingBarButton, searchBarButton]
    }
    
    /// 돋보기 버튼 (종목검색)
    func makeSearchBarButtonItem() -> UIBarButtonItem {
        let searchBarButton = UIBarButtonItem(image: UIImage(systemName: Attributes.searchImage),
                                              style: .plain,
                                              target: self,
                                              action: #selector(touchSearchBarButton))
        searchBarButton.tintColor = .basic
        return searchBarButton
    }
    
    /// 설정 버튼
    func makeSettingBarButtonItem() -> UIBarButtonItem {
        let settingBarButton = UIBarButtonItem(image: UIImage(systemName: Attributes.settingImage),
                                             style: .plain,
                                             target: self,
                                             action: #selector(touchSettingBarButton))
        settingBarButton.tintColor = .basic
        return settingBarButton
    }
    
    // MARK: SubViews
    
    func attributes() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
    }
    
    func register() {
        tableView.register(FavoriteStockListHeaderView.self,
                           forHeaderFooterViewReuseIdentifier: CellID.stockListHeaderView)
        tableView.register(FavoriteStockListTableViewCell.self,
                           forCellReuseIdentifier: CellID.stockListTableViewCell)
        tableView.register(FavoriteStockAdditionTableViewCell.self,
                           forCellReuseIdentifier: CellID.additionTableViewCell)
    }
}
