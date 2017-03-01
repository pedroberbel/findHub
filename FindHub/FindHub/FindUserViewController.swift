//
//  FindUserViewController.swift
//  FindHub
//
//  Created by Pedro Luis Berbel dos Santos on 24/02/17.
//  Copyright © 2017 Santosplb. All rights reserved.
//

import UIKit


class FindUserViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //if there is no data, tableview is hidden
        if self.nameArray.count == 0 {
            self.tableView.isHidden = true
        }
        
    
        self.tableView.dataSource = self
        //setting the colors of navigationBar and TabBar.
        self.navigationController?.navigationBar.barTintColor = Color.azul2()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Color.branco()]
        self.tabBarController?.tabBar.barTintColor = Color.azul2()

    }
    
    var busca = String()
    var URLString = String()
    
    var nameArray = [String]()
    var imageURLArray = [String?]()
    var userURL = [String]()
    
    var selectedUser = String()
    
    //when the "buscar" button is clicked by the user:
    @IBAction func searchButton(_ sender: Any) {

 //condition to check if there is data in the table view, if return true, it will clean the data
        if self.URLString != "" {
            self.userURL = []
            self.URLString = ""
            self.imageURLArray = []
            self.nameArray = []
        }
        //if search bar is not empty, will do the JSON search.
        if !searchBar.text!.isEmpty {
            //busca receiveis what user wrote in search bar, replace spaces by '+', than put it in URL Search 'URLString'
            self.busca = searchBar.text!.replacingOccurrences(of: " ", with: "+")
                        
            self.URLString = "https://api.github.com/search/users?q=\(self.busca)"
     
            self.downloadJsonWithURL()
        }
    }

/* The downloadJsonWithURL() will get the URL from GitHub API user search by JSONSerialization.
     That creates arrays of objects and dictionaries. Each key will have a value, in this case, is searching for 'login','avatar_url'(user's profile picture), 'url'(URL to the selected user
 */
    func downloadJsonWithURL(){
        let url = NSURL(string: self.URLString)
        
        URLSession.shared.dataTask(with: url as! URL, completionHandler: {(data, response, error) -> Void in
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
               
                if let userArray = jsonObj!.value(forKey: "items") as? NSArray {
                    for user in userArray {
                        if let userDict = user as? NSDictionary{
                            
                            if let name = userDict.value(forKey: "login"){
                                self.nameArray.append(name as! String)
                            }
                            if let image = userDict.value(forKey: "avatar_url"){
                                self.imageURLArray.append(image as? String)
                            }
                            if let userLink = userDict.value(forKey: "url"){
                                self.userURL.append(userLink as! String)
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
    
    //the tableview's size are ramdomic according to the number of users founded
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nameArray.count
    
    }
    //will load the data in each tableView Cell, according to the row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellUser") as! TableViewFindUserCell
        
        cell.loginUserLabel.text = self.nameArray[indexPath.row]

        //there is a code to load the user's avatar, without background loading and cashing, turns the application very slowly.
//                let imageURL = NSURL(string: self.imageURLArray[indexPath.row]!)
//                if imageURL != nil {
//                let data = NSData(contentsOf: (imageURL as? URL)!)
//                cell.avatarUserImage.image = UIImage(data: data as! Data)
//                }
        return cell
    }
    //prepare for segue will send to Detail's View, called "SearchUserVC", the user URL, so the application will recognize who it needs to get the detailed information
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userDetail"{
            let searchUserVC = segue.destination as! SearchUserVC
            let myIndexPath = self.tableView.indexPathForSelectedRow!
            let row = myIndexPath.row
            selectedUser = self.userURL[row]
            searchUserVC.userLink = selectedUser
        }
    }

    
    
}
