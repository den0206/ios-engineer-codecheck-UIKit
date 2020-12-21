//
//  RealmManager.swift
//  iOSEngineerCodeCheck
//
//  Created by 酒井ゆうき on 2020/12/19.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import RealmSwift
import PKHUD

///Realmの管理は,当クラスで管理を一任

final class RealmManager {
    
    private let realm = try! Realm()
    private let limit = 20
  
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
            HUD.flash(.labeledSuccess(title: "お気に入り", subtitle: "追加しました"), delay: 1.0)

            /// limit
            if realm.objects(Favorite.self).count == limit + 1 {
                realm.delete(realm.objects(Favorite.self).first!)
            }
            
            print(Realm.Configuration.defaultConfiguration.fileURL!)
            print("call")
        })
    }
    
    /// 引数参照 Repositry && Favorite
    func deleteFavorite(repo : Repositry) {
        
        let favorite = realm.objects(Favorite.self).filter("repoId == \(repo.id)")
        
        try! realm.write({
            realm.delete(favorite)
            HUD.flash(.labeledError(title: "お気に入り", subtitle: "削除しました"), delay: 1.0)

        })
    }
    func deleteFavorite(fav : Favorite) {
        
        try! realm.write({
            realm.delete(fav)
            HUD.flash(.labeledError(title: "お気に入り", subtitle: "削除しました"), delay: 1.0)

        })
    }
    
    func fetchAllFavorite() -> Results<Favorite>{
        var favorites : Results<Favorite>
        favorites = realm.objects(Favorite.self).sorted(byKeyPath: "id", ascending: false)
        
        return favorites
    }
    
    func checkFavorited(repoID : Int) -> Bool {
        
        let checked = realm.objects(Favorite.self).filter("repoId == \(repoID)")
            .count
        
        return checked == 0 ? false : true
    }
}
