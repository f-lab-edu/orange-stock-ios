//
//  FavoriteStockListViewController.swift
//  orange-stock-ios
//
//  Created by hogang on 2023/11/20.
//

import UIKit
import SnapKit

class FavoriteStockListViewController: UIViewController {
    
    private let favListTabelView = UITableView(frame: .zero, style: .plain)
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSubViews()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: IBAction
    
    @objc func touchSearchBarButton() {
//        let pushViewController = SearchStockListViewController()
//        self.navigationController?.pushViewController(pushViewController, animated: true)
    }
}

extension FavoriteStockListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 31
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 마지막 인덱스는 관심종목 추가하기 cell
        if indexPath.row == 30 {
            guard let addFavStockCell = tableView.dequeueReusableCell(withIdentifier: "AddFavoriteStockTableViewCell", for: indexPath) as? AddFavoriteStockTableViewCell else {
                return UITableViewCell()
            }
            return addFavStockCell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteStockListTableViewCell", for: indexPath) as? FavoriteStockListTableViewCell else { return UITableViewCell() }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FavoriteStockListHeaderView") as? FavoriteStockListHeaderView else { return UIView() }
        return headerView
    }
}

private extension FavoriteStockListViewController {
    
    func setSubViews() {
        // 돋보기 버튼
        let searchBarButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"),
                                              style: .plain,
                                              target: self,
                                              action: #selector(touchSearchBarButton))
        searchBarButton.tintColor = .black
        self.navigationItem.rightBarButtonItem = searchBarButton
        
        // 네비 타이틀
        self.navigationController?.navigationBar.prefersLargeTitles = true
        title = "관심 주식 목록"
        
        // 관심 주식 목록
        favListTabelView.rowHeight = UITableView.automaticDimension
        favListTabelView.separatorStyle = .none
        favListTabelView.register(FavoriteStockListHeaderView.self, forHeaderFooterViewReuseIdentifier: "FavoriteStockListHeaderView")
        favListTabelView.register(FavoriteStockListTableViewCell.self, forCellReuseIdentifier: "FavoriteStockListTableViewCell")
        favListTabelView.register(AddFavoriteStockTableViewCell.self, forCellReuseIdentifier: "AddFavoriteStockTableViewCell")
        favListTabelView.dataSource = self
        favListTabelView.delegate = self
    }
    
    func layout() {
        self.view.addSubview(favListTabelView)
        
        favListTabelView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
