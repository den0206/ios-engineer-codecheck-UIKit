//
//  GitHubSeearchResult.swift
//  iOSEngineerCodeCheck
//
//  Created by 酒井ゆうき on 2020/12/18.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//


import Foundation



struct GithubSearchResult : Codable{
    let items : [Repositry]?
}

struct Repositry : Codable,Identifiable{
   
    let id : Int
    let name : String
    let fullName : String
    let htmlURL : String
    let language : String?
    let starCount : Int?
    let wacherscount : Int?
    let forksCount : Int?
    let issuesCount : Int?
    let owner : Owner
    
    var favorited = false
    
    enum CodingKeys: String, CodingKey {
        case id,name,language,owner
        case fullName = "full_name"
        case starCount = "stargazers_count"
        case wacherscount = "wachers_count"
        case forksCount = "forks_count"
        case issuesCount = "open_issues_count"
        case htmlURL = "html_url"
    }
 
}

struct Owner: Codable {
   
    let id: Int
    let login : String
    let avatarURL: String
    let gravatarID: String
   
    enum CodingKeys: String, CodingKey {
        case id,login
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
      
    }
}

