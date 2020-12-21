//
//  DetailConterView.swift
//  iOSEngineerCodeCheck
//
//  Created by 酒井ゆうき on 2020/12/19.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

protocol DetailFooterViewProtocol : class {
    func handleFavorite(footer : DetailFooterView)
}

final class DetailFooterView : UIView {
    
    var repo : Repositry? {
        didSet {
           configure()
        }
    }
    
    weak var delegate : DetailFooterViewProtocol?
    
    //MARK: - parts
    private lazy var langLabel : UILabel = {

        return configureLabel(isBold : true)
    }()
    
    private lazy var starsLabel : UILabel = {
      
        return configureLabel()
        
    }()
    
     private lazy var wathersLabel : UILabel = {
      
        return configureLabel()
        
    }()
    
    private lazy var forksLabel : UILabel = {
      
        return configureLabel()
        
    }()
    
    private lazy var issueLabel : UILabel = {
      
        return configureLabel()
        
    }()
    
    private lazy var favoriteStarImage : UIImageView = {
        
        let iv = UIImageView()
        let ivConfig = UIImage.SymbolConfiguration(pointSize: 30)
     
        iv.image = UIImage(systemName: "star",withConfiguration: ivConfig)
        iv.isUserInteractionEnabled  = true
        iv.tintColor = .gray
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedFavorite))
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        addSubview(langLabel)
        langLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 8, width:frame.width / 2)

        let stack = UIStackView(arrangedSubviews: [starsLabel,wathersLabel,forksLabel,issueLabel,favoriteStarImage])

        stack.axis = .vertical
        stack.alignment = .trailing
        stack.spacing  = 16

        stack.distribution = .equalSpacing

        addSubview(stack)

        stack.anchor(top : langLabel.topAnchor, right : rightAnchor,paddingRight: 16,width:frame.height / 2)
  
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - function
    
    private func configure() {
        
        guard let repo = repo else {return}
        
        langLabel.text = "Written in \(repo.language ?? "")"
        
        starsLabel.text = "\(repo.starCount ?? 0 ) stars"
        wathersLabel.text = "\(repo.wacherscount ?? 0) watchers"
        forksLabel.text = "\(repo.forksCount ?? 0) forks"
        issueLabel.text = "\(repo.issuesCount ?? 0) open issues"
        
        configureStarImage(repo: repo)

        
    }
    
    @objc func tappedFavorite() {
        
        delegate?.handleFavorite(footer: self)

    }
    
   //MARK: - UI Extensions
    
    private func configureLabel(isBold : Bool = false, size : CGFloat = 17) -> UILabel {
        let label = UILabel()
        
        switch isBold {
        
        case true :
            label.font = UIFont.boldSystemFont(ofSize: size)
        case false :
            label.font = UIFont.systemFont(ofSize: size)
        }
       
        label.text = "Sample"
        
        return label
    }
    
    func configureStarImage(repo : Repositry) {
      
        switch repo.favorited {
        case true :
            favoriteStarImage.image = UIImage(systemName: "star.fill")
            favoriteStarImage.tintColor = .yellow
        case false :
            favoriteStarImage.image = UIImage(systemName: "star")
            favoriteStarImage.tintColor = .gray
       
        }
    }

}



