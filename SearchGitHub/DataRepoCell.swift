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
    
    // Find time difference between today and the latest update.
    static private func intervalTimeFrom(date gitHubDate: String?) -> String {
        
        guard let dateGitHub = gitHubDate else { return "" }
        
        var dateLastUpdate:Date!
        
        if #available(iOS 10.0, *) {
            let dateFormat = ISO8601DateFormatter()
            dateFormat.timeZone = TimeZone(abbreviation: "UTC")
            dateLastUpdate = dateFormat.date(from: dateGitHub)
        } else {
            let dateFormat = DateFormatter()
            dateFormat.timeZone = TimeZone(abbreviation: "UTC")
            dateLastUpdate = dateFormat.date(from: dateGitHub)
        }
        
        let dateComponent = DateComponentsFormatter()
        dateComponent.unitsStyle = .short
        dateComponent.allowedUnits = [.year,.month,.day,.hour,.minute]
        
        return dateComponent.string(from: dateLastUpdate, to: Date())!
    }
}

extension DataRepoCell {
    init(with repo: GHRepository) {
        
        username = repo.owner?.login ?? ""
        
        repoName = repo.name ?? ""
        repoAddress = repo.html_url ?? ""
        hasIconProyect = repo.has_projects ?? false
        
        lastUpdate = DataRepoCell.intervalTimeFrom(date: repo.pushed_at) //repo.created_at ?? "" }
        
        
        // Find Avatar.
        let url = URL(string: (repo.owner?.avatar_url)!)
        
        let data = try? Data(contentsOf: url!)
        self.avatar = UIImage(data: data!)!
    }
}
