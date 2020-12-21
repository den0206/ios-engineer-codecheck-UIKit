//
//  FavoriteCell.swift
//  iOSEngineerCodeCheck
//
//  Created by 酒井ゆうき on 2020/12/19.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit
import SDWebImage

final class FavoriteCell : UICollectionViewCell {
    
    static let reuseIdentifier = "favoriteCell"

    var favorite : Favorite? {
        didSet {
            configure()
        }
    }
    
    //MARK: - Parts
    
    private let avatarImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.setDimension(width: 45, height: 45)
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 45 / 2
  
        return iv
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 1
        label.text = "Sample"
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 35 / 2
        backgroundColor = .systemGroupedBackground
        
        addSubview(avatarImageView)
        avatarImageView.centerX(inView: self)
        avatarImageView.anchor(top :topAnchor, paddingTop: 16)
        
        addSubview(titleLabel)
        titleLabel.anchor(top : avatarImageView.bottomAnchor, left : leftAnchor,right: rightAnchor,paddingTop: 16, paddingLeft: 4,paddingRight: 8)

        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configure
    
    private func configure() {
        
        guard let favorite = favorite else {return}
        
        let url = URL(string: favorite.thumbnailUrl)
        avatarImageView.sd_setImage(with: url)

        titleLabel.text = favorite.title
    
    }
}
