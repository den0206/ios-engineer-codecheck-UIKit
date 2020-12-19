//
//  RealmManager.swift
//  iOSEngineerCodeCheck
//
//  Created by 酒井ゆうき on 2020/12/19.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import RealmSwift

///Realmの管理は,当クラスで管理を一任

final class RealmManager {
    
    let realm = try! Realm()
  
    func addFavorite(repo : Repositry) {
        
        let favorite = Favorite()
        
        let title = repo.fullName
        let repoId = repo.id
        let thumbnailUrl = repo.owner.avatarURL
        
        if realm.objects(Favorite.self).count != 0 {
            favorite.id = realm.objects(Favorite.self).max(ofProperty: "id")! + 1
        }
        
        try! realm.write({
            favorite.title = title
            favorite.repoId = repoId
            favorite.thumbnailUrl = thumbnailUrl
            
            realm.add(favorite, update: .all)
            
            print(Realm.Configuration.defaultConfiguration.fileURL!)
            print("call")
        })
    }
    
    func deleteFavorite(repo : Repositry) {
        
        let favorite = realm.objects(Favorite.self).filter("repoId == \(repo.id)")
        
        try! realm.write({
            realm.delete(favorite)
        })
    }
    
    func checkFavorited(repoID : Int) -> Bool {
        
        let checked = realm.objects(Favorite.self).filter("repoId == \(repoID)")
            .count
        
        return checked == 0 ? false : true
    }
}
