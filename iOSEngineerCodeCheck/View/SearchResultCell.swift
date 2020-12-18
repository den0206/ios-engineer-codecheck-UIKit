//
//  RepositryCell.swift
//  iOSEngineerCodeCheck
//
//  Created by 酒井ゆうき on 2020/12/18.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

final class SearchResultCell : UITableViewCell {
    
    static let Identifer = "searchResultCell"
    
    //MARK: - Parts
    
    let titleLabel : UILabel = {
        let label = UILabel()
        
        label.text = "Example"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .none
        
        addSubview(titleLabel)
        titleLabel.centerY(inView: self)
        titleLabel.anchor(left : leftAnchor,paddingLeft: 10)
     
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
