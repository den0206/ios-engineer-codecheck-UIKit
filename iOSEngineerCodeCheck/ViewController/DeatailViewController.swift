//
//  DeatailViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 酒井ゆうき on 2020/12/18.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class DetailViewController : UIViewController {
    
    //MARK: - Properties

    var repositry : Repositry
    
    private let RM = RealmManager()
    private let screenHight = UIScreen.main.bounds.height
    private let topPadding : CGFloat = 5
    
    /// footer はview表示毎に,checkfavoritedを行う為
    var footer : DetailFooterView!
    var didLoad = true
   
    //MARK: - LifeCycle

    
    init(repo : Repositry) {
        
        self.repositry = repo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        repositry.favorited = RM.checkFavorited(repoID: repositry.id)
        configureUI()
        
        didLoad = false
  
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !didLoad {
            repositry.favorited = RM.checkFavorited(repoID: repositry.id)
            footer.repo = repositry
        }
    }
    
    //MARK: - UI
    
    private func configureUI() {
        
        navigationItem.title = repositry.name
        navigationController?.navigationBar.isTranslucent = false
        view.backgroundColor = .white
        
        let header  = DetailHeaderView(frame: CGRect(x: 0, y: topPadding, width: view.frame.width, height:screenHight / 2))
        header.repo = repositry
        
        view.addSubview(header)
        
        footer = DetailFooterView(frame:CGRect(x: 0, y: screenHight / 2 + topPadding, width: view.frame.width, height:screenHight / 2))
        
        footer.delegate = self
        footer.repo = repositry
        
        view.addSubview(footer)

    }
}

//MARK: - Manage Favorite

extension DetailViewController : DetailFooterViewProtocol {
    
    func tappedUrl(footer: DetailFooterView) {
        
        if let url = URL(string:repositry.htmlURL) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
 
        }
    }
    
    
    func handleFavorite(footer: DetailFooterView) {
        
        if repositry.favorited {
            /// remove fav
            RM.deleteFavorite(repo: repositry)
        } else {
            /// add fav
            RM.addFavorite(repo: repositry)
        }
        
        repositry.favorited.toggle()
        footer.configureStarImage(repo: repositry)
    }

    
}
