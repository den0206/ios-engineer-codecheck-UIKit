//
//  SearchViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 酒井ゆうき on 2020/12/18.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

final class SearchViewController : UITableViewController {
    
    var repositries = [Repositry]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var service = APIService()
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        
        configureNav()
        configureTableView()
        
    }
    
    
    
    //MARK: - Functions
    
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
    }
    
    private func configureTableView() {
        
        tableView.rowHeight = 60
        
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.Identifer)
        
        tableView.tableFooterView = UIView()
   
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
        
        tableView.deselectRow(at: indexPath, animated: true)
        print( indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.item == repositries.count - 1 {
            
            service.searchRepo() { (repos, error) in
                
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                
                self.repositries.append(contentsOf: repos)
                print(self.repositries.count, self.service.currentPage)
            }
        }
    }
}


//MARK: - UISearchResultsUpdating, UISearchBarDelegate

extension SearchViewController : UISearchResultsUpdating, UISearchBarDelegate {
    
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        repositries.removeAll()
        
        guard let text = searchBar.text else {return}
        
        service.searchWord = text
        
        service.searchRepo() { (repos, error) in
            
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            self.repositries = repos
            self.searchController.isActive = false
            
        }
    }
}
