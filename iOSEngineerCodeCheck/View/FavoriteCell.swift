//
//  FavoriteCell.swift
//  iOSEngineerCodeCheck
//
//  Created by 酒井ゆうき on 2020/12/19.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

final class FavoriteCell : UICollectionViewCell {
    
    static let reuseIdentifier = "favoriteCell"
    
    //MARK: - Parts
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.lineBreakMode = .byCharWrapping
        label.text = "Sample"
        label.numberOfLines = 0
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 35 / 2
        backgroundColor = .systemGroupedBackground
        
        addSubview(titleLabel)
        titleLabel.anchor(top : topAnchor, left: leftAnchor,right: rightAnchor, paddingTop: 10,paddingLeft: 10,paddingRight: 10)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
