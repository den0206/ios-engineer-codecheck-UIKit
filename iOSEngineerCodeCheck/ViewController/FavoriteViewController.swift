//
//  FavoriteViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 酒井ゆうき on 2020/12/19.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit
import RealmSwift

final class FavoriteViewController : UICollectionViewController, MainTabControllerDelegate {
    
    var favorites : Results<Favorite>!
    
    var service = APIService()

    let RM = RealmManager()
    var token : NotificationToken!
    
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 25.0, bottom: 20.0, right: 25.0)
    private let itemsPerRow : CGFloat = 2
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureCV()
        fetchFavorites()
        
    }
    
    //MARK: - UI
    
    private func configureCV() {
        navigationItem.title = "Favorite"
        
        collectionView.backgroundColor = .white
        collectionView.register(FavoriteCell.self, forCellWithReuseIdentifier: FavoriteCell.reuseIdentifier)
        
    }
    
    //MARK: - Favorite
    
    private func fetchFavorites() {
        
        guard Reachabilty.HasConnection() else {
            showAlert(message: "No Internet connection")
            return
        }
        
        favorites = RM.fetchAllFavorite()
        
        /// Favorites の監視を付与
        token = favorites.observe({ [weak self] _ in
            self?.collectionView.reloadData()
        })
    }
    
    /// Tab選択時に,Collectionview最上部にスクロール
    func didSelectTab(tabBarController: UITabBarController) {
        
        guard favorites != nil else {return}
        
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
}

//MARK: - UICollectionView Delegate

extension FavoriteViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorites != nil ? favorites.count : 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(_:)))

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCell.reuseIdentifier, for: indexPath) as! FavoriteCell
        
        cell.favorite = favorites[indexPath.item]
        
        cell.addGestureRecognizer(longPressGesture)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var fav : Favorite
        fav = favorites[indexPath.item]
        
        self.tabBarController?.showLoadindView(true)
        
        /// Favorite ID から API経由でRepo情報を獲得,遷移
        
        service.fetchSpecificRepo(repoId: fav.repoId) { (repo, error) in
            
            if error != nil {
                self.tabBarController?.showLoadindView(false)
                self.showAlert(message: error!.localizedDescription)
                return
            }
            
            guard let repo = repo else {
                self.tabBarController?.showLoadindView(false)
                return
            }
            
            self.tabBarController?.showLoadindView(false)
            
            let detailVC = DetailViewController(repo: repo)
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
        
    }
    
    //MARK: - Delete
    
    @objc func longPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        /// ロングタップアイテムの特定
        if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
            let touchPoint = longPressGestureRecognizer.location(in: collectionView)
            if let index = collectionView.indexPathForItem(at: touchPoint) {
               deleteItem(index: index)
                
            }
        }
    }
    
    private func deleteItem(index : IndexPath) {
        let realm = try! Realm()
        let favorite = favorites[index.item]
        
        let alert = UIAlertController(title: "Delete", message: "お気に入りを削除しても宜しいでしょうか？", preferredStyle: .alert)
       alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
       
       alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
           self.collectionView.deleteItems(at: [index])
        
        try! realm.write {
            realm.delete(favorite)
        }
           
       }))
        
        present(alert, animated: true, completion: nil)
    }
    
}

//MARK: -  UICollectionViewDelegateFlowLayout

extension FavoriteViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left
    }

}
