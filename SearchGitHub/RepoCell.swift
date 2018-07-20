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
    
    
    func load(repo: DataRepoCell) {
        
        // Find Avatar.
        avatar.image = repo.avatar
        avatar.circular()
        
        fullNameRepo.text = repo.repoName
        userRepoName.text = "by: " + repo.username
        
        iconProjects.isHidden = !repo.hasIconProyect
        
        // Find last update.
        updateRepo.text = "Last update: " + repo.lastUpdate
    }
}
