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
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false
        
        tableView.tableFooterView = searchBar
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath) as! RepoCell
        
        // Find Avatar.
        let url = URL(string: self.repositories[indexPath.row].owner.avatar_url)
        let data = try? Data(contentsOf: url!)
        
        cell.avatar.image = UIImage(data: data!)
        cell.avatar.circular()
        
        cell.fullNameRepo.text = self.repositories[indexPath.row].full_name
        
        // Find last update.
        cell.updateRepo.text = self.repositories[indexPath.row].updated_at
        
        return cell
    }
    
}

extension RepositoriesTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        
        APIGitHub.repositories(by: searchText) { (array) in
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
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
}
