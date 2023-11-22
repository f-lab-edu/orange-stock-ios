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
    
    private enum CellIdentifier {
        static let stockListTableViewCell = "FavoriteStockListTableViewCell"
        static let additionTableViewCell = "FavoriteStockAdditionTableViewCell"
        static let stockListHeaderView = "FavoriteStockListHeaderView"
    }
    
    // MARK: Properties
    
    private var favoriteStockList: [Stock] = []
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavtaionBar()
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
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CellIdentifier.stockListHeaderView)
         as? FavoriteStockListHeaderView ?? UIView()
        return headerView
    }
    
    private func stockListTableViewCellForRowAt(_ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.stockListTableViewCell, for: indexPath) as? FavoriteStockListTableViewCell
        else { return UITableViewCell() }
        cell.stock(self.favoriteStockList[indexPath.row])
        return cell
    }
    
    private func additionTableViewCellForRowAt(_ indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: CellIdentifier.additionTableViewCell, for: indexPath) as? FavoriteStockAdditionTableViewCell ?? UITableViewCell()
    }
}

// MARK: Layout

private extension FavoriteStockListViewController {
    
    private enum Title {
        static let navigationTitle = "관심 주식 목록"
    }
    
    private enum SystemImage {
        static let searchBarButtonImage = "magnifyingglass"
    }
    
    func setNavtaionBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        title = Title.navigationTitle
        
        let searchBarButton = UIBarButtonItem(image: UIImage(systemName: SystemImage.searchBarButtonImage),
                                              style: .plain,
                                              target: self,
                                              action: #selector(touchSearchBarButton))
        searchBarButton.tintColor = Color.basic
        self.navigationItem.rightBarButtonItem = searchBarButton
    }
    
    func attributes() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
    }
    
    func register() {
        tableView.register(FavoriteStockListHeaderView.self, forHeaderFooterViewReuseIdentifier: CellIdentifier.stockListHeaderView)
        tableView.register(FavoriteStockListTableViewCell.self, forCellReuseIdentifier: CellIdentifier.stockListTableViewCell)
        tableView.register(FavoriteStockAdditionTableViewCell.self, forCellReuseIdentifier: CellIdentifier.additionTableViewCell)
    }
}
