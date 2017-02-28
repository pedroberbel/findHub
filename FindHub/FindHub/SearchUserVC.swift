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
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    
    var userLink = String()
    
    final var urlString = ""
    final let urlReposString = "https://api.github.com/users/pedroberbel/repos"
//    final var reposURL = [String]()
    var reposURL = [String]()
    var reposName = [String]()
    var reposDescription = [String]()
    
    var nameArray = [String]()
    var followersArray = [NSNumber]()
    var followingArray = [NSNumber]()
    var imageUrl = [String]()
    var repository = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.urlString = userLink
        self.downloadJsonWithURL()
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
                    self.repository.append(repos as! String)
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
                    print("FOI AQUI: ")
//                 self.downloadJsonWithURLrepos()
            }
        }.resume()
    }

// get data from repos_url:
    func downloadJsonWithURLrepos(){
       
        print("chamou RepoFunc")
//        var urlRepos = self.repository as? String
        let urli = NSURL(string: urlReposString)
        print(urlReposString)
        
        URLSession.shared.dataTask(with: (urli as? URL)!) { (data, response, error) -> Void in
            print ("DATA:")
            print(data)

            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary{
                print("Entrou...")
                if let nome = jsonObj!.value(forKey: "name"){
                    self.reposName.append(nome as! String)
                    print("entrou mais...")
                }
            
                
                
                
//                if let nome = jsonObj?.value(forKey: "name") as? NSArray{
//                    print("entrou mais...")
//                    for name in nome {
//                        if let reposDict = name as? NSDictionary{
//                            if let lolo = reposDict.value(forKey: "name"){
//                                self.reposName.append(lolo as! String)
//                                print("Concluiu")
//                            }
//                        }
//                    }
//                    
//                }
            
            }
        
        }.resume() //URLSession
        } //dJWU
    
    
    
    
    
// Return the repositories from that user

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
//      return 1
        return reposName.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewUserRepCell
    
        return cell
    }
    public func numberOfSections(in tableView: UITableView) -> Int {
      
        return 1
    }

    

    
}
