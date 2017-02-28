//
//  FindReposViewController.swift
//  FindHub
//
//  Created by Pedro Luis Berbel dos Santos on 24/02/17.
//  Copyright © 2017 Santosplb. All rights reserved.
//

import UIKit

class FindReposViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
   
    var busca = String()
    var nameArray = [String]()
    var ownerArray = [String]()
    var languageArray = [String?]()
    var URLString = String()
    var lastUpdateArray = [String]()
    var teste1 = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.nameArray.count == 0 {
            self.tableView.isHidden = true
        }
            self.tableView.dataSource = self
        
        self.tableView.dataSource = self
        self.tableView.dataSource = self
        self.navigationController?.navigationBar.barTintColor = Color.azul2()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Color.branco()]
        self.tabBarController?.tabBar.barTintColor = Color.azul2()
    }

    
    @IBAction func searchButton(_ sender: Any) {
        
        if self.URLString != "" {
            self.URLString = ""
            self.ownerArray = []
            self.nameArray = []
            self.languageArray = []
        }
        
        if !searchBar.text!.isEmpty {
            self.busca = searchBar.text!.replacingOccurrences(of: " ", with: "+")
            
            print("busca repositorios acionada")
            //https://api.github.com/search/repositories?q=teste
            
            let busca = "repositories" //quando botao de buscar usuario for acionado
                        
            self.URLString = "https://api.github.com/search/\(busca)?q=\(self.busca)"
            
            print(self.URLString)
            self.downloadJsonWithURL()
        } else {
            print("busca vazia")
            searchBar.tintColor = UIColor.red
            searchBar.barTintColor = UIColor.red
            
        }
    } // end button
    
    func downloadJsonWithURL(){
        let url = NSURL(string: self.URLString)
        print (url)
        URLSession.shared.dataTask(with: url as! URL, completionHandler: {(data, response, error) -> Void in
            print("entrou1")
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                print("entrou")
                if let reposArray = jsonObj!.value(forKey: "items") as? NSArray {
                    for repository in reposArray {
                        if let reposDict = repository as? NSDictionary{
                            // get the reporitory's name
                            if let name = reposDict.value(forKey: "name"){
                                self.nameArray.append(name as! String)
                            }
                            if let language = reposDict.value(forKey: "language"){
                                self.languageArray.append(language as? String)
                                }
                            if let lastUpdate = reposDict.value(forKey: "updated_at"){
                                self.lastUpdateArray.append(lastUpdate as! String)
                            }
                                // acessa dados do dono do repositório:
                            if let owner = reposDict.value(forKey: "owner"){
                                print("OWNER")
                                print((owner as AnyObject).value(forKey: "login"))
                                if let login = (owner as AnyObject).value(forKey: "login"){
                                    self.ownerArray.append(login as! String)
                                }
                            }

                            
                            self.tableView.isHidden = false
                    
                            OperationQueue.main.addOperation {
                                self.tableView.reloadData()
                                print("ATUALIZOU A TABELA")
                            }
                        }
                    }
                }
            }
            
        }).resume()
        
        print("OWNSERS LIST:")
        print(self.ownerArray)
    }
    

      
        
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.nameArray.count
//        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellRepos") as! TableViewFindReposCell
        
        cell.repositoryNameLabel.text = self.nameArray[indexPath.row] //funcionou p1
        cell.ownerLoginLabel.text = self.ownerArray[indexPath.row] //funcionou p1
        cell.languageLabel.text = self.languageArray[indexPath.row] 
        cell.lastUpdateLabel.text = self.lastUpdateArray[indexPath.row]
        
    return cell
    }

}
