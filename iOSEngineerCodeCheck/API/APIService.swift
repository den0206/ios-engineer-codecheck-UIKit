//
//  APIManager.swift
//  iOSEngineerCodeCheck
//
//  Created by 酒井ゆうき on 2020/12/18.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import Foundation

//API処理は当クラスで管理を一任

final class APIService {
    
    var searchWord : String = ""
    var currentPage = 0
    
    private let decorder = JSONDecoder()
    let per_Page = 20
    
    func searchRepos(completion : @escaping(Result<[Repositry], Error>) -> Void) {
        
        var repositries = [Repositry]()
        
        let baseUrl = "https://api.github.com/search/repositories?q=\(searchWord)&page=\(currentPage)&per_page=\(per_Page)"
        
        guard let url = URL(string: baseUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
            completion(.failure(APIError.noUrl))
            return
        }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { (data, _, error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let safeData = data else {
                completion(.failure(APIError.NoData))
                return
                
            }
            
            do {
                let decorderData = try self.decorder.decode(GithubSearchResult.self, from: safeData)
                
                if decorderData.items != nil {
                    
                    DispatchQueue.main.async {
                        
                        repositries.append(contentsOf: decorderData.items!)
                        
                        completion(.success(repositries))
                        
                        self.currentPage += 1
                       
                    }
                }
                
            } catch {
                completion(.failure(error))
                return
            }
            
            
        }
        task.resume()
    }
    
    func fetchRepo(repoId : Int, completion : @escaping(Result<Repositry , Error>) -> Void ) {
        
        let baseUrl = "https://api.github.com/repositories/\(repoId)"
        
        guard let url = URL(string: baseUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
            
            completion(.failure(APIError.noUrl))
            return
            
        }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { (data, _, error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let safeData = data else {
                completion(.failure(APIError.NoData))
                return
                
            }
            
            let decorder = JSONDecoder()
            
            do {
                let repoData = try decorder.decode(Repositry.self, from: safeData)
                
                DispatchQueue.main.async {
                    completion(.success(repoData))

                }
            } catch {
                
                completion(.failure(error))
                return
            }
        }
        task.resume()
    }
    
    func resetService() {
        searchWord = ""
        currentPage = 0
    }
}
