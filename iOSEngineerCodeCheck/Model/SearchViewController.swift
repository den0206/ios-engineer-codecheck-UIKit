//
//  SearchViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 酒井ゆうき on 2020/12/18.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit
import SwiftUI

final class SearchViewController : UITableViewController,MainTabControllerDelegate {
    
    //MARK: - Properties

    /// @AppStorage を使用の為,SwiftUIをimport
    @AppStorage("useIncremental") var useIncremental = true
    
    var repositries = [Repositry]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let service = APIService()
    private let tableViewEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    let searchController = UISearchController(searchResultsController: nil)
    
    var reachLast = false
    var timer : Timer?
    
    //MARK: - LifeCycle

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureNav()
        configureTableView()
        
    }

    //MARK: - UI
    
    private func configureNav() {
        
        navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.title = "Search"
        configureSearch()
        
    }
    
    private func configureTableView() {
        
        tableView.rowHeight = 60
        tableView.contentInset = tableViewEdgeInsets
        tableView.scrollIndicatorInsets = tableViewEdgeInsets
        tableView.tableFooterView = UIView()
        
        tableView.accessibilityIdentifier = SearchResultCell.reuseIdentifier
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.reuseIdentifier)

    }
    
    private func setupBarButtonItem() {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 8)
        label.text = "リアルタイム検索"

        let toggle = UISwitch()
        toggle.isOn = useIncremental
        toggle.addTarget(self, action: #selector(toggleValueChanged(_:)), for: .valueChanged)
        
        let stackView = UIStackView(arrangedSubviews: [label, toggle])
        stackView.spacing = 8

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: stackView)
    }
    
    @objc func toggleValueChanged(_ toggle: UISwitch) {
        
        switch toggle.isOn {
        case true :
            useIncremental = true
        case false :
            useIncremental = false
        }
    }
    
    /// Tab選択時に,最上部にスクロール
    func didSelectTab(tabBarController: UITabBarController) {
        guard repositries.count > 0 else {return}
        
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    
    }
    
}

//MARK: - TableView Delegate

extension SearchViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
       
        guard repositries.count > 0 else {
            ///Label - "検索結果がありません" 表示
            let label = NoResultLabel(type: .Repositry)
            label.frame = tableView.frame
            tableView.backgroundView = label
            return 0
        }
        
        tableView.backgroundView = nil
        return 1
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return repositries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        ///今後カスタマイズできる為,カスタム Cellの作成・仕様
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.reuseIdentifier, for: indexPath) as! SearchResultCell
        
        cell.repositry = repositries[indexPath.row]
        
        return  cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var repo : Repositry
        
        repo = repositries[indexPath.row]
        
        let detailVC = DetailViewController(repo: repo)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
    /// for pagenation
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard !reachLast else {return}
        
        if indexPath.item == repositries.count - 1 {
                    
            sendRequest(isPagination: true)
        }
    }
}



//MARK: - UISearchResultsUpdating, UISearchBarDelegate

extension SearchViewController : UISearchResultsUpdating, UISearchBarDelegate {
    
    /// インクリメンタルサーチ
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if useIncremental {
            
            guard let text = searchController.searchBar.text else {return}
            guard text != "" else {return}
            
            resetSearch()
            
            service.searchWord = text
            timer?.invalidate()
            /// リクエストの間隔を0.5秒に設定,
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
                self.sendRequest()
            })
            
        }
        
    }

    /// SearchButton クリック時
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if  !useIncremental {
            
            guard let text = searchBar.text else {return}
            guard text != "" else {return}
            
            resetSearch()
            service.searchWord = text
            sendRequest()
        }
     
    }
    
    /// 当ViewCopntroller API通信の一任
    func sendRequest(isPagination : Bool = false) {
        
        self.timer?.invalidate()

        guard Reachabilty.HasConnection() else {
            resetSearch()
            searchController.isActive = false
            showAlert(message: "No Internet Connection")
            return
        }
        
        self.tabBarController?.showLoadindView(true)
        
        service.searchRepos { (result) in
            
            switch result {
            case .success(let repos):
                
                if repos.count > 0 {
                    switch isPagination {
                    
                    case true :
                        self.repositries.append(contentsOf: repos)

                    case false :
                        self.repositries = repos
                    }
                } else {
                    self.reachLast = true
                }
                
            case .failure(let error):
                self.showAlert(message: error.localizedDescription)
                
            }
            
            self.searchController.isActive = false
            self.tabBarController?.showLoadindView(false)
 
        }
        
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resetSearch()
    }
    
    private func resetSearch(deleteWord : Bool = true ) {
        reachLast = false
        repositries.removeAll()
        
        service.resetService()
    }
    
    
    private func configureSearch() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false

        
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Search Repositry"
        searchController.searchBar.searchTextField.backgroundColor = .systemBackground
        searchController.searchBar.autocapitalizationType = .none
        
        setupBarButtonItem()
    }
    
}

