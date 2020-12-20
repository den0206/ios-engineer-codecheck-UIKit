//
//  MainTabViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 酒井ゆうき on 2020/12/19.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

protocol MainTabControllerDelegate {
    func didSelectTab(tabBarController: UITabBarController)
}

final class MainTabController : UITabBarController , UITabBarControllerDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        configureTabController()
   
    }
    
    private func configureTabController() {
        
        /// TabBar選択時の色
        UITabBar.appearance().tintColor = .black

        let searchVC = SearchViewController()
        let nav1 = templeteNavigationController(image: UIImage(systemName: "magnifyingglass"), title: "Search", rootViewController: searchVC)
        
        let favoriteVC = FavoriteViewController()
        let nav2 = templeteNavigationController(image: UIImage(systemName: "star"), title: "Favotite", rootViewController: favoriteVC)
        
        self.delegate = self
        viewControllers = [nav1,nav2]
        
    }
    
    //MARK: - 基本的な NavigationVC を生成
    
    private func templeteNavigationController(image : UIImage?, title : String,rootViewController : UIViewController) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: rootViewController)
        
        let appearence = UINavigationBarAppearance()
        appearence.configureWithOpaqueBackground()
        
        /// set basic Color
        appearence.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
        appearence.backgroundColor = UIColor.white
        UINavigationBar.appearance().tintColor = .black
        
        nav.navigationBar.standardAppearance = appearence
        nav.navigationBar.compactAppearance = appearence
        nav.navigationBar.scrollEdgeAppearance = appearence
        
        nav.tabBarItem.image = image
        nav.tabBarItem.title = title
        
        return nav
  
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        let viewController = viewController as! UINavigationController
        
        if viewController.viewControllers.first is SearchViewController {
            let vc = viewController.viewControllers.first  as! SearchViewController
            /// Tab選択時に, TableView最上部にスクロール
            vc.didSelectTab(tabBarController: self)
        } else if viewController.viewControllers.first is FavoriteViewController {
            let vc = viewController.viewControllers.first  as! MainTabControllerDelegate
            /// Tab選択時に,Collectionview最上部にスクロール
            vc.didSelectTab(tabBarController: self)
        }
        

    }
}
