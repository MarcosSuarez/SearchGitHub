//
//  RepositoriesTableViewController.swift
//  SearchGitHub
//
//  Created by Marcos Suarez on 17/7/18.
//  Copyright © 2018 Marcos Suarez. All rights reserved.
//

import UIKit
import SafariServices

class RepositoriesTableViewController: UITableViewController, SFSafariViewControllerDelegate {
    
    var repositories = [DataRepoCell]()
    
    var loadingIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        // Add background image
        let imageBackground = UIImageView(image: UIImage(named: "github-octocat.png"))
        imageBackground.contentMode = .scaleAspectFit
        tableView.backgroundColor = UIColor.lightGray
        tableView.backgroundView = imageBackground
        
        // Activity indicator
        setupLoading()
    }
    
    // MARK: - Methods
    func setupLoading() {
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = .whiteLarge
        loadingIndicator.stopAnimating()
        loadingIndicator.center = self.view.center
        loadingIndicator.layer.backgroundColor = UIColor.black.cgColor
        self.view.addSubview(loadingIndicator)
    }
    
    // MARK: - Safari
    private func goRepositoryDetail(url: String) {
        
        guard let urlrepository = URL(string: url) else { return }
        
        let safari = SFSafariViewController(url: urlrepository)
        
        present(safari, animated: true)
        
        safari.delegate = self
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
        
        cell.load(repo: repositories[indexPath.row])
        
        // Control page.
        if !APIGitHub.isLoading, indexPath.row == Int(repositories.count * 3/4),
            APIGitHub.pagination.nextPage < APIGitHub.pagination.lastPage {
            // add new page
            APIGitHub.repositories(by: APIGitHub.pagination.nextURLpage) { (nextRepositories) in
                
                print("total nuevos repositorios Agregados: ", nextRepositories.count)
                
                nextRepositories.forEach({ (repository) in
                    let data = DataRepoCell(with: repository)
                    self.repositories.append(data)
                })
                
                print("TOTAL repositorios en móvil: ",self.repositories.count)
                
                // Update data in Cell
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Go to detail.
        goRepositoryDetail(url: repositories[indexPath.row].repoAddress)
    }
}

//MARK: - Search bar
extension RepositoriesTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        
        repositories.removeAll()
        tableView.reloadData()
        
        APIGitHub.repositories(by: searchText) { (array) in
            
            print("total nuevos repositorios: ", array.count)
            
            array.forEach({ (repository) in
                let data = DataRepoCell(with: repository)
                self.repositories.append(data)
            })
            
            // Update data in Cell
            DispatchQueue.main.async {
                self.loadingIndicator.stopAnimating()
                self.loadingIndicator.isHidden = true
                self.tableView.reloadData()
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
}
