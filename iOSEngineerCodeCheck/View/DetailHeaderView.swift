//
//  DetailHeaderView.swift
//  iOSEngineerCodeCheck
//
//  Created by 酒井ゆうき on 2020/12/18.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit
import SDWebImage

final class DetailHeaderView : UIView {
    
    var repo : Repositry? {
        didSet {
            configure()
        }
    }
    
    //MARK: - Parts
    
    private let imageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        
        return iv
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Sample"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height - 50)
        addSubview(imageView)
        
        addSubview(titleLabel)
        titleLabel.centerX(inView: self)
        titleLabel.anchor(top : imageView.bottomAnchor, bottom: bottomAnchor, paddingTop: 12)
     
    }
    
  
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        guard let repo = repo else {return}
        
        let url = URL(string : repo.owner.avatarURL)
        imageView.sd_setImage(with: url)
        
        titleLabel.text = repo.fullName
    }
    
    
}
