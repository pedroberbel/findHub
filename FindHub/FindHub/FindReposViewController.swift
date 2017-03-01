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
    var URLString = String()
    
    var nameArray = [String]()
    var languageArray = [String?]()
    var lastUpdateArray = [String]()
    var ownerArray = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //if there is no data, tableview is hidden
        if self.nameArray.count == 0 {
            self.tableView.isHidden = true
        }
            self.tableView.dataSource = self
        
          //setting the colors of navigationBar and TabBar.
        self.tableView.dataSource = self
        self.tableView.dataSource = self
        self.navigationController?.navigationBar.barTintColor = Color.azul2()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Color.branco()]
        self.tabBarController?.tabBar.barTintColor = Color.azul2()
    }


    @IBAction func searchButton(_ sender: Any) {
     //condition to check if there is data in the table view, if return true, it will clean the data       
        if self.URLString != "" {
            self.URLString = ""
            self.ownerArray = []
            self.nameArray = []
            self.languageArray = []
            self.lastUpdateArray = [] 
        }
            //if search bar is not empty, will do the JSON search.
        if !searchBar.text!.isEmpty {
            //busca receiveis what user wrote in search bar, replace spaces by '+', than put it in URL Search 'URLString'
            self.busca = searchBar.text!.replacingOccurrences(of: " ", with: "+")

            self.URLString = "https://api.github.com/search/repositories?q=\(self.busca)"

            self.downloadJsonWithURL()
        }
    }
    
 /* The downloadJsonWithURL() function will access the JSON by it URL using JSONSerialization, ccreating arrays ans dictionaries wich one have some value for a key. In that case it is getting the repositories names and putting in a array "nameArray", same for the language (but that could return null), same for the lastUpdateArray and the owners login "ownerArray"
 */
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
                            // get this language, could be null
                            if let language = reposDict.value(forKey: "language"){
                                self.languageArray.append(language as? String)
                                }
                            
                            if let lastUpdate = reposDict.value(forKey: "updated_at"){
                                self.lastUpdateArray.append(lastUpdate as! String)
                            }
                                //access to the repository owner's data
                            if let owner = reposDict.value(forKey: "owner"){
                                if let login = (owner as AnyObject).value(forKey: "login"){
                                    self.ownerArray.append(login as! String)
                                }
                            }
            // refresh tableView in the main thread, more fastly
                            OperationQueue.main.addOperation {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
            //if there is no results in the search, the tableview will turn hidden
            if self.nameArray.isEmpty{
                self.tableView.isHidden = true
            } else {
                self.tableView.isHidden = false
            }
        }).resume()
    }
    
    
    //the tableview's size are ramdomic according to the number of repositories founded
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nameArray.count
    }
    //will load the data in each tableView Cell, according to the row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellRepos") as! TableViewFindReposCell
        
        cell.repositoryNameLabel.text = self.nameArray[indexPath.row]
        cell.ownerLoginLabel.text = self.ownerArray[indexPath.row]
        cell.languageLabel.text = self.languageArray[indexPath.row] 
        cell.lastUpdateLabel.text = self.lastUpdateArray[indexPath.row]
        
    return cell
    }

}
