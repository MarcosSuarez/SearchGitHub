//
//  RepositoriesTableViewController.swift
//  SearchGitHub
//
//  Created by Marcos Suarez on 17/7/18.
//  Copyright © 2018 Marcos Suarez. All rights reserved.
//

import UIKit
import SafariServices

class RepositoriesTableViewController: UIViewController, SFSafariViewControllerDelegate {
    
    var repositories = [DataRepoCell]()
    
    var loadingIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var btnPublicProyects: UIButton!
    
    override func viewDidLoad() {
        
        // Add background image
        let imageBackground = UIImageView(image: UIImage(named: "github-octocat.png"))
        imageBackground.contentMode = .scaleAspectFit
        tableView.backgroundColor = UIColor.lightGray
        tableView.backgroundView = imageBackground
        
        // Activity indicator
        setupLoading()
        
        // Button public proyects
        btnPublicProyects.tintColor = .white
        btnPublicProyects.backgroundColor = tableView.backgroundColor
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
    
    func loadData(from urlGitHub: String) {
        APIGitHub.repositories(by: urlGitHub) { (nextRepositories) in
            
            print("total nuevos repositorios Agregados: ", nextRepositories.count)
            
            nextRepositories.forEach({ (repository) in
                let data = DataRepoCell(with: repository)
                self.repositories.append(data)
            })
            
            print("TOTAL repositorios en móvil: ",self.repositories.count)
            
            // Update data in Cell
            DispatchQueue.main.async {
                self.loadingIndicator.stopAnimating()
                self.loadingIndicator.isHidden = true
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Safari
    private func goRepositoryDetail(url: String) {
        
        guard let urlrepository = URL(string: url) else { return }
        
        let safari = SFSafariViewController(url: urlrepository)
        
        present(safari, animated: true)
        
        safari.delegate = self
    }
    
    // MARK: - Search
    func startSearch() {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        
        repositories.removeAll()
        APIGitHub.resetPagination()
        tableView.reloadData()
        
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        loadData(from: (isPressed ? searchText + APIGitHub.publicProyect : searchText))
        
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
    }
    
    var isPressed:Bool = false
    // MARK: - Filter proyects
    @IBAction func pressedFilterButton(_ sender: UIButton) {
       
        isPressed = !isPressed
        sender.tintColor = (isPressed) ? searchBar.tintColor : .white
        startSearch()
    }
}

extension RepositoriesTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath) as! RepoCell
        
        cell.load(repo: repositories[indexPath.row])
        
        // Control page.
        if !APIGitHub.isLoading, indexPath.row == Int(repositories.count * 3/4),
            APIGitHub.pagination.nextPage < APIGitHub.pagination.lastPage {
            // add new page
            loadData(from: APIGitHub.pagination.nextURLpage)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Go to detail.
        goRepositoryDetail(url: repositories[indexPath.row].repoAddress)
    }
}

//MARK: - Search bar
extension RepositoriesTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        startSearch()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
}
