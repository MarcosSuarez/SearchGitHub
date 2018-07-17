//
//  ViewController.swift
//  SearchGitHub
//
//  Created by Marcos Suarez on 16/7/18.
//  Copyright © 2018 Marcos Suarez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //"MarcandoLaRuta"
        APIGitHub.repositories(by:"tetris+language:assembly&sort=stars&order=desc") { (array) in
            print("total repositorios: ", array.count)
            let ordenado = array.sorted(by: { $0.owner.login.lowercased() < $1.owner.login.lowercased() })
            
            ordenado.forEach({ (repositorio) in
                print(repositorio.owner.login)
            })
        }
    }
    
    

}

