//
//  RepoCell.swift
//  SearchGitHub
//
//  Created by Marcos Suarez on 18/7/18.
//  Copyright © 2018 Marcos Suarez. All rights reserved.
//

import UIKit

class RepoCell: UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var fullNameRepo: UILabel!
    @IBOutlet weak var updateRepo: UILabel!
    
    @IBOutlet weak var userRepoName: UILabel!
    @IBOutlet weak var iconProjects: UIImageView!
    
    
    func load(repo: GHRepository) {
        
        // Find Avatar.
        if let url = URL(string: (repo.owner?.avatar_url)!) {
            let data = try? Data(contentsOf: url)
            avatar.image = UIImage(data: data!)
            avatar.circular()
        }
        
        fullNameRepo.text = repo.name
        userRepoName.text = "by: " + (repo.owner?.login ?? "")
        
        iconProjects.isHidden = !(repo.has_projects ?? false)
        
        // Find last update.
        updateRepo.text = "Last update: " + (repo.updated_at ?? "")
    }
}
