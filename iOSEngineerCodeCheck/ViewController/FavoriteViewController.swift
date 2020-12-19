//
//  FavoriteViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 酒井ゆうき on 2020/12/19.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

final class FavoriteViewController : UICollectionViewController, MainTabControllerDelegate {
 
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
        
    }
    
    //MARK: - UI
    
    private func configureCV() {
        navigationItem.title = "Favorite"
        
        collectionView.backgroundColor = .white
        collectionView.register(FavoriteCell.self, forCellWithReuseIdentifier: FavoriteCell.reuseIdentifier)
        
    }
    
    /// TabItem 選択時に Favorite reload
    func didSelectTab(tabBarController: UITabBarController) {
        print("ReCall")
    }
    
}

//MARK: - UICollectionView Delegate

extension FavoriteViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCell.reuseIdentifier, for: indexPath) as! FavoriteCell
        
        return cell
    }
    
    
}

//MARK: -  UICollectionViewDelegateFlowLayout

extension FavoriteViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left
    }

}
