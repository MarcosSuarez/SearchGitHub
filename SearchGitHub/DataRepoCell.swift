//
//  DataRepoCell.swift
//  SearchGitHub
//
//  Created by Marcos Suarez on 20/7/18.
//  Copyright © 2018 Marcos Suarez. All rights reserved.
//

import UIKit

struct DataRepoCell {
    var username: String
    var avatar:UIImage
    
    var repoName: String
    var repoAddress: String
    var lastUpdate: String
    var hasIconProyect: Bool
}

extension DataRepoCell {
    init(with repo: GHRepository) {
        
        username = repo.owner?.login ?? ""
        
        repoName = repo.name ?? ""
        repoAddress = repo.html_url ?? ""
        lastUpdate = repo.created_at ?? ""// Modificar para que incluya la foto.
        hasIconProyect = repo.has_projects ?? false
        
        // Find Avatar.
        let url = URL(string: (repo.owner?.avatar_url)!)
        
        let data = try? Data(contentsOf: url!)
        self.avatar = UIImage(data: data!)!
    }
}
