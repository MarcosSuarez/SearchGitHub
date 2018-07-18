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
    let name: String // repository name
    let full_name: String // "user login / repository name"
    let owner: GHOwner
    let created_at: String //"created_at": "2016-09-19T19:31:57Z",
    let updated_at: String //"updated_at": "2016-09-19T19:35:15Z",
    let language: String //"language": "Swift"
    let html_url: String // Repository Web
    let description: String?
}

struct GHOwner: Codable {
    let login: String // User login
    let avatar_url: String // URL user avatar
    let html_url: String // User github Web
}

/// API to request information from GitHub
class APIGitHub {
    
    private static let basePath = "https://api.github.com/"
    private static let searchRepo = "search/repositories?q="
    
    private init() {}
    
    /// Search repositories by String.
    static func repositories(by: String, completion: @escaping ([GHRepository])-> Void) {
        
        guard let url = URL(string: basePath + searchRepo + by) else { completion([]); return }
        print("URL: \n",url)
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else {
                print("--- request failed: \n",error ?? "Error hasn't description")
                completion([])
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let myStruct = try decoder.decode(GHSearchRepo.self, from: data)
                    completion(myStruct.items)
                } catch {
                    print("--- Error when decoding: ",error.localizedDescription)
                }
            }
            }.resume()
    }
}
