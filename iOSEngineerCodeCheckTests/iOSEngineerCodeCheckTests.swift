//
//  iOSEngineerCodeCheckTests.swift
//  iOSEngineerCodeCheckTests
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import XCTest
import RealmSwift

@testable import iOSEngineerCodeCheck

class iOSEngineerCodeCheckTests: XCTestCase {
        
    var searchVC : SearchViewController!
    var favoriteVC : FavoriteViewController!
    var ranNum : Int!
    
    ///　realm Databese の使用
    let RM = RealmManager()
    
    override func setUp() {
        super.setUp()
        
        /// SearchViewController 構成
        configureSV()
        
        /// FavoriteViewController 構成
        configureFavoriteVC()
    
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    //MARK: - SearchViewController Test
    
    func testSearchVCSectionCount() {
        
        let sectionCount = searchVC.numberOfSections(in: searchVC.tableView)
        
     
        if searchVC.repositries.count == 0 {
            /// サーチ前ではSection数は0
            XCTAssertEqual(sectionCount, 0)
        } else {
            XCTAssertEqual(sectionCount, 1)
        }
    }
   
    func testSearchVCRownCount() {
        
        let cellCount = searchVC.tableView.numberOfRows(inSection: 0)
        XCTAssertEqual(cellCount, searchVC.repositries.count)
    }
    
    func testSearchVCCellTitle() {
        
        let num = searchVC.repositries.count - 1
        
        let cell = searchVC.tableView.dataSource?.tableView(searchVC.tableView, cellForRowAt: IndexPath(row: num, section: 0)) as! SearchResultCell
        XCTAssertEqual(cell.titleLabel.text, searchVC.repositries[num].fullName)
        
    }
    
    //MARK: - FavoriteViewController Test

    func testFavoriteVCSectionCount() {

        let sectionCount = favoriteVC.numberOfSections(in: favoriteVC.collectionView)
        
        /// 当CollectionView Section数 は 1に固定
        XCTAssertEqual(sectionCount, 1)

    }
    func testFavoriteVCRownCount() {

        let itemCount = favoriteVC.collectionView(favoriteVC.collectionView, numberOfItemsInSection: 0)
        XCTAssertEqual(itemCount, favoriteVC.favorites.count)
    }

    func testFavoriteVCCellTitle() {
        
        guard favoriteVC.favorites != nil && favoriteVC.favorites.count > 0 else {
           XCTAssert(true, "No Favorite")
            return
        }
        
        let num = favoriteVC.favorites.count - 1
        
        let item = favoriteVC.collectionView.dataSource?.collectionView(favoriteVC.collectionView, cellForItemAt: IndexPath(item: num, section: 0)) as! FavoriteCell
        XCTAssertEqual(item.titleLabel.text, favoriteVC.favorites[num].title)

    }

}

extension iOSEngineerCodeCheckTests {
    
    //MARK: - Configure ViewController
    
    private func configureSV() {
        
        ranNum = Int.random(in: 1 ... 100)
        
        searchVC = SearchViewController()
        searchVC.tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.reuseIdentifier)
        searchVC.repositries = Array(repeating: generateEXRepo(), count: ranNum)
    }
    
    private func configureFavoriteVC() {
        
        favoriteVC = FavoriteViewController()
        favoriteVC.collectionView.register(FavoriteCell.self, forCellWithReuseIdentifier: FavoriteCell.reuseIdentifier)
        favoriteVC.favorites = RM.fetchAllFavorite()
    }
    //MARK: - Generate Random Repositry
    
    private func generateEXRepo() -> Repositry{
        
        let id = Int.random(in: 1 ... 10000)
        let name = randomString()
        let fullname = randomString()
        
        let ownerId = Int.random(in: 1 ... 10000)
        let login = randomString()
        let avatarURL = randomString()
        let gravatarID = randomString()
 
        let owner : Owner = .init(id: ownerId, login: login, avatarURL: avatarURL, gravatarID: gravatarID)
        
        let repo : Repositry = .init(id: id, name: name, fullName: fullname, htmlURL: "URL", language: nil, starCount: nil, wacherscount: nil, forksCount: nil, issuesCount: nil, owner: owner)
        
        return repo
    }
    

    func randomString(length: Int = 5) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
}

