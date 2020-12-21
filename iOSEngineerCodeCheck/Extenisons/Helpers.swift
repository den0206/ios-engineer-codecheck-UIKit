//
//  Helpers.swift
//  iOSEngineerCodeCheck
//
//  Created by 酒井ゆうき on 2020/12/19.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController {
    
    func showAlert(title : String = "Error", message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }


    var topbarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
    
    func showLoadindView(_ present : Bool, message : String? = "Loading...") {
        
        if present {
            
            let blackView = UIView()
            blackView.frame = self.view.bounds
            blackView.backgroundColor = .black
            blackView.alpha = 0
            blackView.tag = 1
            
            let indicator = UIActivityIndicatorView()
            indicator.color = .white
            indicator.style = .large
            indicator.center = blackView.center
            
            let label = UILabel()
            label.text = message
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = .white
            label.textAlignment = .center
            label.alpha = 0.7
            
            self.view.addSubview(blackView)
            blackView.addSubview(indicator)
            blackView.addSubview(label)
            
            label.centerX(inView: view)
            label.anchor(top : indicator.bottomAnchor,paddingTop: 23)
            
            indicator.startAnimating()
            
            UIView.animate(withDuration: 0.2) {
                blackView.alpha = 0.7
            }
            
            
        } else {
            
            // hide
            view.subviews.forEach { (subview) in
                
                if subview.tag == 1 {
                    UIView.animate(withDuration: 0.5, animations: {
                        subview.alpha = 0
                    }) { (_) in
                        subview.removeFromSuperview()
                    }
                }
            }
            
        }
    }
    
}

//MARK: - TableView & CollectionView用のデータが存在しない時

final class NoResultLabel : UILabel {
    
    enum DataType {
        case Repositry,Favorite
    }
    
    var dataType : DataType
    
    private let noResultLabel: UILabel =  {
       let label = UILabel()
        label.text = "検索結果がありません"
        label.textColor = UIColor.black
        label.textAlignment = .center
        return label
    }()
    
    init(type : DataType) {
        self.dataType = type
        super.init(frame: .zero)
        
        addSubview(noResultLabel)
        
        noResultLabel.center(inView: self)
        
        switch type {
    
        case .Repositry:
            noResultLabel.text = "検索結果がありません"
        case .Favorite:
            noResultLabel.text = "お気に入りがありません"
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



