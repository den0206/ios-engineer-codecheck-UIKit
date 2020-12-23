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
    func tappedUrl(footer : DetailFooterView)
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
    
    private lazy var urlLabel : UILabel = {
       
        let label = configureLabel()
        
        /// 下部線あり
        let attributedString = NSMutableAttributedString.init(string: "リンク先")
          attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range:
              NSRange.init(location: 0, length: attributedString.length));
        
        label.attributedText = attributedString
        label.textColor = .systemBlue
        label.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedUrl))
        label.addGestureRecognizer(tap)
        
        return label
        
    }()
    
    
    
    private lazy var favoriteStarImage : UIImageView = {
        
        let iv = UIImageView()
     
        iv.image = UIImage(systemName: "star")
        iv.isUserInteractionEnabled  = true
        iv.tintColor = .gray
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedFavorite))
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        let leftstack = UIStackView(arrangedSubviews: [langLabel, urlLabel])
        
        leftstack.axis = .vertical
        leftstack.alignment = .leading
        leftstack.spacing  = 16
        
        addSubview(leftstack)

        leftstack.anchor(top: topAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 8, width:frame.width / 2)

        let rightstack = UIStackView(arrangedSubviews: [favoriteStarImage,starsLabel,wathersLabel,forksLabel,issueLabel])

        rightstack.axis = .vertical
        rightstack.alignment = .trailing
        rightstack.spacing  = 16

        rightstack.distribution = .equalSpacing

        addSubview(rightstack)

        rightstack.anchor(top : leftstack.topAnchor, right : rightAnchor,paddingRight: 16,width:frame.height / 2)
  
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
    
    @objc func tappedUrl() {
        delegate?.tappedUrl(footer: self)
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
        
        let ivConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)

        switch repo.favorited {
        case true :
            favoriteStarImage.image = UIImage(systemName: "star.fill",withConfiguration: ivConfig)
            favoriteStarImage.tintColor = .yellow
        case false :
            
            favoriteStarImage.image = UIImage(systemName: "star", withConfiguration: ivConfig)
            favoriteStarImage.tintColor = .gray
       
        }
    }

}



