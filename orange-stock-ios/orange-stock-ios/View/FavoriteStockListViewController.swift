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
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        attributes()
        register()
    }
    
    // MARK: Actions
    
    @objc func touchSearchBarButton() {
        
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
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: .stockListHeaderView)
         as? FavoriteStockListHeaderView ?? UIView()
        return headerView
    }
    
    private func stockListTableViewCellForRowAt(_ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: .stockListTableViewCell,
                                                       for: indexPath) as? FavoriteStockListTableViewCell
        else { return UITableViewCell() }
        cell.stock(self.favoriteStockList[indexPath.row])
        return cell
    }
    
    private func additionTableViewCellForRowAt(_ indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: .additionTableViewCell,
                                             for: indexPath) as? FavoriteStockAdditionTableViewCell
         ?? UITableViewCell()
    }
}

// MARK: Layout

private extension FavoriteStockListViewController {

    func setNavigation() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        title = .navigationTitle
        
        let searchBarButton = UIBarButtonItem(image: UIImage(systemName: .searchBarButtonImage),
                                              style: .plain,
                                              target: self,
                                              action: #selector(touchSearchBarButton))
        searchBarButton.tintColor = .basic
        self.navigationItem.rightBarButtonItem = searchBarButton
    }
    
    func attributes() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
    }
    
    func register() {
        tableView.register(FavoriteStockListHeaderView.self, forHeaderFooterViewReuseIdentifier: .stockListHeaderView)
        tableView.register(FavoriteStockListTableViewCell.self, forCellReuseIdentifier: .stockListTableViewCell)
        tableView.register(FavoriteStockAdditionTableViewCell.self, forCellReuseIdentifier: .additionTableViewCell)
    }
}

private extension String {
    // navigation
    static let navigationTitle = "관심 주식 목록"
    static let searchBarButtonImage = "magnifyingglass"
    
    // Cell Identifier
    static let stockListTableViewCell = "FavoriteStockListTableViewCell"
    static let additionTableViewCell = "FavoriteStockAdditionTableViewCell"
    static let stockListHeaderView = "FavoriteStockListHeaderView"
}
