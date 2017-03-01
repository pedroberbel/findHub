//
//  SearchUserVC.swift
//  FindHub
//
//  Created by Pedro Luis Berbel dos Santos on 22/02/17.
//  Copyright © 2017 Santosplb. All rights reserved.
//

import Foundation
import UIKit




class SearchUserVC: UIViewController, UITableViewDataSource {
    
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    
    var userLink = String()
    
    final var urlString = ""
    var urlReposString = String()

    var reposURL = [String]()
    var reposName = [String]()
    var reposDescription = [String?]()
    
    var nameArray = [String]()
    var followersArray = [NSNumber]()
    var followingArray = [NSNumber]()
    var imageUrl = [String]()

    var reposNameArray = [String]()
    var languageArray = [String?]()
    var lastUpdateArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        
        self.urlString = userLink
        self.downloadJsonWithURL()
        print("REPOS STRING")
        print(urlReposString)
//        self.downloadJsonReposWithURL()
        //loading a rounded avatar and made it fixed with clipstoBounds
        userAvatar.clipsToBounds = true
//        userAvatar.layer.cornerRadius = userAvatar.frame.size.width/2
       userAvatar.layer.cornerRadius = 10
        // Do any additional setup after loading the view, typically from a nib.
    }
    //vai aparecer as informações na tela
//    override func viewWillAppear(_ animated: Bool) {
//
//    
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
        // Dispose of any resources that can be recreated.
    }
    

    
//getting data from JSON, after found the user (in the details View)
    func downloadJsonWithURL(){
        let url = NSURL(string: urlString)
        URLSession.shared.dataTask(with: (url as? URL)!) { (data, response, error) -> Void in
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary{
                
                if let login = jsonObj?.value(forKey: "login"){
                self.nameArray.append(login as! String)
                }
                
                if let followers = jsonObj?.value(forKey: "followers"){
                    self.followersArray.append(followers as! NSNumber)
                }
                
                if let following = jsonObj?.value(forKey: "following"){
                    self.followingArray.append(following as! NSNumber)
                }
                
                if let image = jsonObj?.value(forKey: "avatar_url"){
                    self.imageUrl.append(image as! String)
                }
              
                if let repos = jsonObj?.value(forKey: "repos_url"){
                    self.urlReposString.append(repos as! String)
                    print ("dentro da funcao")
                    print (self.urlReposString)
                self.downloadJsonReposWithURL()

                }
                
                
                //GCD Library. updates in the main thread:
                DispatchQueue.main.async(execute: {
                    self.loginLabel.text = self.nameArray[0] as? String
                    self.followersLabel.text = String(describing: self.followersArray[0])
                    self.followingLabel.text = String(describing: self.followingArray[0])
                //for avatarImage: (3lines)
                    let imageURL = NSURL(string: self.imageUrl[0])
                    let data = NSData(contentsOf: (imageURL as! URL))
                    self.userAvatar.image = UIImage(data: data as! Data)
                    
                })
//                    print("FOI AQUI: ")
            }
        }.resume()
    }

// get data from repos_url:
    func downloadJsonReposWithURL(){
        let url = NSURL(string: urlReposString)
        URLSession.shared.dataTask(with: (url as? URL)!) { (data, response, error) -> Void in
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSArray{
//                    print("JSON OBJ")
//                    print(jsonObj)
                
                if let reposArray = jsonObj! as? NSArray {
                
                    for repository in reposArray {
                        if let reposDict = repository as? NSDictionary{
//                              print("DICIONARIO")
//                              print(reposDict)
                            // get the reporitory's name
                            if let name = reposDict.value(forKey: "name"){
                                self.reposNameArray.append(name as! String)
                                print("NOMES")
                                print(self.reposNameArray)
                            }
                            if let language = reposDict.value(forKey: "language"){
                                self.languageArray.append(language as? String)
////                                print("LNAGUAGE")
////                                print(self.languageArray)
                            }
                            if let lastUpdate = reposDict.value(forKey: "updated_at"){
                                self.lastUpdateArray.append(lastUpdate as! String)
                            }
                            if let descr = reposDict.value(forKey: "description"){
                                self.reposDescription.append(descr as? String)
                            }
                            OperationQueue.main.addOperation {
                                self.tableView.reloadData()
                                print("ATUALIZOU A TABELA")
                                
                            }
                        }
                    }}
            
            }
        }.resume()
    
    }
    
    
    
    
    
// Return the repositories from that user

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
//      return 2
        return reposNameArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewUserRepCell
        
        cell.repsitoryLabel.text = self.reposNameArray[indexPath.row]
        cell.descriptionLabel.text = self.reposDescription[indexPath.row]
        cell.languageLabel.text = self.languageArray[indexPath.row]
        cell.lastUpdateLabel.text = self.lastUpdateArray[indexPath.row]
        
        return cell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        self.tableView.sectionIndexColor = Color.azul2()
        
        return 1
    }
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var text = "Repositórios: \(self.reposNameArray.count)"
        return text
    }

    

    
}
