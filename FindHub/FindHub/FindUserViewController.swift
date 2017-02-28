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
        
        if self.nameArray.count == 0 {
            self.tableView.isHidden = true
        }
        
    
        self.tableView.dataSource = self
        self.navigationController?.navigationBar.barTintColor = Color.azul2()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Color.branco()]
        self.tabBarController?.tabBar.barTintColor = Color.azul2()

       

    }

    var URLString = String()
    var nameArray = [String]()
    var imageURLArray = [String?]()
    var arraySize = Int()
    var busca = String()
    var userURL = [String]()
    
    
    @IBAction func searchButton(_ sender: Any) {

        
        
        if self.URLString != "" {
            self.userURL = []
            self.URLString = ""
            self.imageURLArray = []
            self.nameArray = []
        }
        
        if !searchBar.text!.isEmpty {
            self.busca = searchBar.text!.replacingOccurrences(of: " ", with: "+")
            
            print("busca acionada")
            
            let busca = "users" //quando botao de buscar usuario for acionado
                        
            self.URLString = "https://api.github.com/search/\(busca)?q=\(self.busca)"
            
            print(self.URLString)
            self.downloadJsonWithURL()
        } else {
            print("busca vazia")
            searchBar.tintColor = UIColor.red
            searchBar.barTintColor = UIColor.red

        }
    }


    func downloadJsonWithURL(){
        let url = NSURL(string: self.URLString)
        print (url)
        URLSession.shared.dataTask(with: url as! URL, completionHandler: {(data, response, error) -> Void in
            print("entrou1")
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                print("entrou")
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
                          
                            OperationQueue.main.addOperation {
                                self.tableView.reloadData()
                                print("ATUALIZOU A TABELA")
                                
                            }
                        
                        }
                    }
                }
     
            }
            if self.nameArray.isEmpty{
                self.tableView.isHidden = true
                
            } else {
                
                self.tableView.isHidden = false
            }
        }).resume()
    
    }
    
//    func imageCache(image: String) {
//        
//        DispatchQueue.global(qos: .userInitiated).async {
//        self.imageURLArray.append(image as! String)
//        DispatchQueue.main.async {
//            for i in 0..<30 {
//            self.imageURLArray[i] = image
//            //            return img as! [String]
//            }
//            }}
////        return img as! [String]
//        
//    }
//    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nameArray.count
    
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellUser") as! TableViewFindUserCell
        
        cell.loginUserLabel.text = self.nameArray[indexPath.row]

//                let imageURL = NSURL(string: self.imageURLArray[indexPath.row]!)
//                if imageURL != nil {
//                let data = NSData(contentsOf: (imageURL as? URL)!)
//                cell.avatarUserImage.image = UIImage(data: data as! Data)
//                }
        

        
        return cell
    }
    
    var selectedUser = String()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userDetail"{
            let searchUserVC = segue.destination as! SearchUserVC
            let myIndexPath = self.tableView.indexPathForSelectedRow!
            let row = myIndexPath.row
            selectedUser = self.userURL[row]
            searchUserVC.userLink = selectedUser
        }
    }
    
 
    
    
    
//    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "userDetail" {
//            if let nextVC = segue.destination as? SearchUserVC {
//                nextVC.selectedUser = sender as! String
//            }
//        }
//    }
    
    
}
