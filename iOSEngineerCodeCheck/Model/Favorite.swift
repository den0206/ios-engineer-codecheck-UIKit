//
//  Favorite.swift
//  iOSEngineerCodeCheck
//
//  Created by 酒井ゆうき on 2020/12/19.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import RealmSwift

final class Favorite : Object {
    
    @objc dynamic var id = 0
    @objc dynamic var repoId = 0
    
    @objc dynamic var title = ""
    @objc dynamic var thumbnailUrl = ""
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
