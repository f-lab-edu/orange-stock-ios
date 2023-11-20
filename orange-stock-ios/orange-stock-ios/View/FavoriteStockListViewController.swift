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
        
    }
}

extension FavoriteStockListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteStockListTableViewCell", for: indexPath) as? FavoriteStockListTableViewCell else { return UITableViewCell() }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FavoriteStockListHeaderView") as? FavoriteStockListHeaderView else { return UIView() }
        return headerView
    }
}

private extension FavoriteStockListViewController {
    
    func setSubViews() {
        // 네비바 상단 투명하게
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
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
        favListTabelView.rowHeight = 50.0
        favListTabelView.separatorStyle = .none
        favListTabelView.register(FavoriteStockListHeaderView.self, forHeaderFooterViewReuseIdentifier: "FavoriteStockListHeaderView")
        favListTabelView.register(FavoriteStockListTableViewCell.self, forCellReuseIdentifier: "FavoriteStockListTableViewCell")
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
