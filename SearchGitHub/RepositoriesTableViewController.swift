//
//  RepositoriesTableViewController.swift
//  SearchGitHub
//
//  Created by Marcos Suarez on 17/7/18.
//  Copyright © 2018 Marcos Suarez. All rights reserved.
//

import UIKit

class RepositoriesTableViewController: UITableViewController {

    var repositories = [GHRepository]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false
        
        APIGitHub.repositories(by: "MarcandoLaRuta") { (array) in
            print("total repositorios: ", array.count)
            self.repositories = array.sorted(by: { $0.owner.login.lowercased() < $1.owner.login.lowercased() })
            
            self.repositories.forEach({ (repositorio) in
                print(repositorio.owner.login)
            })
            
            // Update data in Cell
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath)

        return cell
    }
    
}
