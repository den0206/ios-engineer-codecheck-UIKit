//
//  DeatailViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 酒井ゆうき on 2020/12/18.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

final class DetailViewController : UIViewController {
    
    let repositry : Repositry
    
    private let screenHight = UIScreen.main.bounds.height
    private let topPadding : CGFloat = 5
    
    
    init(repo : Repositry) {
        
        self.repositry = repo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    
    override func viewDidLoad() {
       
        configureUI()
    }
    
    //MARK: - UI
    
    private func configureUI() {
        
        navigationController?.navigationBar.isTranslucent = false

        view.backgroundColor = .white
        let header  = DetailHeaderView(frame: CGRect(x: 0, y: topPadding, width: view.frame.width, height:screenHight / 2))
        header.repo = repositry
        
        view.addSubview(header)
        
        let footer = DetailFooterView(frame:CGRect(x: 0, y: screenHight / 2 + topPadding, width: view.frame.width, height:screenHight / 2))
        
        footer.repo = repositry
        
        view.addSubview(footer)

    }
}
