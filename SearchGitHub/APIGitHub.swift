//
//  APIGitHub.swift
//  SearchGitHub
//
//  Created by Marcos Suarez on 16/7/18.
//  Copyright © 2018 Marcos Suarez. All rights reserved.
//

import Foundation

/// response struct of GitHub
struct GHSearchRepo: Codable {
    let total_count: Int
    let incomplete_results: Bool
    let items: [GHRepository]
}

/// repository structure
struct GHRepository: Codable {
    let name: String? // repository name
    let full_name: String? // "user login / repository name"
    let owner: GHOwner?
    let created_at: String? //"created_at": "2016-09-19T19:31:57Z",
    let updated_at: String? //"updated_at": "2016-09-19T19:35:15Z",
    let language: String? //"language": "Swift"
    let html_url: String? // Repository Web
    let description: String?
    let has_projects: Bool?
}

struct GHOwner: Codable {
    let login: String? // User login
    let avatar_url: String? // URL user avatar
    let html_url: String? // User github Web
}

/// API to request information from GitHub
class APIGitHub {
    
    struct GHPagination {
        var nextPage:String = "&page=1"
        var previosPage:String = "&page=1"
        var lastPage:String = "&page=1"
    }
    
    private static let basePath = "https://api.github.com/"
    private static let searchRepo = "search/repositories?q="
    private static let hasProyectPath = "+has_projects"
    
    static var withPublicProyect:Bool = false
    
    static var pagination = GHPagination()
    
    private init() {}
    
    /// Search repositories by String.
    static func repositories(by: String, completion: @escaping ([GHRepository])-> Void) {
        
        let textSearch = by.replacingOccurrences(of: " ", with: "+")
        
        guard let url = URL(string: basePath + searchRepo + textSearch + (withPublicProyect ? hasProyectPath : "") ) else { completion([]); return }
        print("URL: \n",url)
        
        URLSession.shared.dataTask(with: url) { (data:Data?, response: URLResponse?, error: Error?) in
            
            guard error == nil else {
                print("--- request failed: \n",error ?? "Error hasn't description")
                completion([])
                return
            }
            
            setupPagination(response: response, textSearch: textSearch)
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let myStruct = try decoder.decode(GHSearchRepo.self, from: data)
                    print("Resultados Incompletos: ",myStruct.incomplete_results)
                    print("Total de repositorios: ",myStruct.total_count)
                    completion(myStruct.items)
                } catch {
                    print("--- Error when decoding: ",error.localizedDescription)
                }
            }
            }.resume()
    }
    
    private static func setupPagination(response: URLResponse?, textSearch: String) {
        /* Example Github HEADER Link
         <https://api.github.com/search/repositories?q=Swift&page=29>; rel="prev",
         <https://api.github.com/search/repositories?q=Swift&page=31>; rel="next",
         <https://api.github.com/search/repositories?q=Swift&page=34>; rel="last",
         <https://api.github.com/search/repositories?q=Swift&page=1>; rel="first"
        */
        
        if let httpResponse = response as? HTTPURLResponse,
            let linkHeader = httpResponse.allHeaderFields["Link"] as? String {
            
            // separated components by ,
            let links = linkHeader.components(separatedBy: ",")
            
            links.forEach({
                let linkComponents = $0.components(separatedBy:"; ")
                let cleanborder = linkComponents[0].replacingOccurrences(of: ">", with: "")
                let cleanPage = cleanborder.replacingOccurrences(of: "<", with: "")
                
                if linkComponents[1].contains("prev") {
                    pagination.previosPage = cleanPage
                }
                
                if linkComponents[1].contains("next") {
                    pagination.nextPage = cleanPage
                }
                
                if linkComponents[1].contains("last") {
                    pagination.lastPage = cleanPage
                }
            })
        }
        
        print(pagination)
        
    } // End setupPagination
}
