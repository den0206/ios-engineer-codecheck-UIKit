//
//  SearchViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 酒井ゆうき on 2020/12/18.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit
import SwiftUI

final class SearchViewController : UITableViewController {
    
    var repositries = [Repositry]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var service = APIService()
    var reachLast = false
    
    let searchController = UISearchController(searchResultsController: nil)
    @AppStorage("useIncremental") var useIncremental = true
    var timer : Timer?
    
    
    override func viewDidLoad() {
        
        configureNav()
        configureTableView()
        
    }

    //MARK: - UI
    
    private func configureNav() {
        
        self.navigationItem.title = "Search"
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Search Repositry"
        searchController.searchBar.searchTextField.backgroundColor = .systemBackground
        searchController.searchBar.autocapitalizationType = .none
        
        setupBarButtonItem()
        
    }
    
    private func configureTableView() {
        
        navigationController?.navigationBar.isTranslucent = false

        tableView.rowHeight = 60
        
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top:5 , left: 0, bottom: 5, right: 0)
        
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.Identifer)

        
        tableView.tableFooterView = UIView()
        
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
}

//MARK: - TableView Delegate

extension SearchViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return repositries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        ///今後カスタマイズできる為,カスタム Cellの作成・仕様
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.Identifer, for: indexPath) as! SearchResultCell
        
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
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resetSearch()
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
    
    func sendRequest(isPagination : Bool = false) {
        
        self.timer?.invalidate()

        guard Reachabilty.HasConnection() else {
            searchController.isActive = false
            showAlert(message: "No Internet Connection")
            return
        }
        
        self.navigationController?.showLoadindView(true)
        
        service.searchRepo() { (repos, error) in
            
            if error != nil {
                
                self.showAlert(message: error!.localizedDescription)
                self.navigationController?.showLoadindView(false)

                return
            }
            
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
            
            self.searchController.isActive = false
            self.navigationController?.showLoadindView(false)

            
        }
     
    }
    
    private func resetSearch() {
        reachLast = false
        repositries.removeAll()
        service.resetService()
    }
    
    
}

