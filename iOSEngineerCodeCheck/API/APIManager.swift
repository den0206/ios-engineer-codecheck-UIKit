//
//  APIManager.swift
//  iOSEngineerCodeCheck
//
//  Created by 酒井ゆうき on 2020/12/18.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import Foundation


class APIService {
    
    var searchWord : String = ""
    var currentPage = 0
    
    let per_Page = 20
    
    func searchRepo(completion : @escaping([Repositry], Error?) -> Void ) {
        
        var repositries = [Repositry]()
        
        let baseUrl = "https://api.github.com/search/repositories?q=\(searchWord)&page=\(currentPage)&per_page=\(per_Page)"
        
        guard let url = URL(string: baseUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {return }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { (data, _, error) in
            
            if error != nil {
                print(error!.localizedDescription)
                completion(repositries, error)
                return
            }
            
            guard let safeData = data else {return}
            
            let decorder = JSONDecoder()
            
            do {
                let decorderData = try decorder.decode(GithubSearchResult.self, from: safeData)
                
                if decorderData.items != nil {
                    DispatchQueue.main.async {
                        
                        repositries.append(contentsOf: decorderData.items!)
                        completion(repositries,nil)
                        
                        self.currentPage += 1
                       
                    }
                    
                }
                
            } catch {
                completion(repositries,error)
            }
        }
        task.resume()
        
    }
}
