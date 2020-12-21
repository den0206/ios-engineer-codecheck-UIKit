//
//  FavoriteHeaderView.swift
//  iOSEngineerCodeCheck
//
//  Created by 酒井ゆうき on 2020/12/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

final class FavoriteHeaderView : UICollectionReusableView {
    
    static let reuseIdentifier = "favoriteHeaderView"
    
    //MARK: - Parts
    
    var favoriteConterLabel : UILabel = {
        
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "itle label"
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(favoriteConterLabel)
        favoriteConterLabel.centerY(inView: self)
        favoriteConterLabel.anchor(right : rightAnchor,paddingRight: 10)
        
        /// 下部線
        let underLine = UIView()
        underLine.backgroundColor = .black
        
        addSubview(underLine)
        underLine.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor,height: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
