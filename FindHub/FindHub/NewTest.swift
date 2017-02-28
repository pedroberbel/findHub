//
//  NewTest.swift
//  FindHub
//
//  Created by Pedro Luis Berbel dos Santos on 24/02/17.
//  Copyright © 2017 Santosplb. All rights reserved.
//


import UIKit
import Foundation


class NewTest: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    @IBAction func reposButton(_ sender: Any) {
    }

    //botao de teste1
    @IBAction func testButton(_ sender: Any) {
        } //button
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
    }
    
    var ownerArray = [String]()
    var busca = String()
    var URLString = String()
    var nameArray = [String]()
    var imageURLArray = [String]()
    var languageArray = [String]()
    
//    func variables(_ names:[String],_ images:[String]){
//     
//     self.nameArray = names
//     self.imageURLArray = images
//        print("recebeu os dados")
//        print(self.nameArray)
//        
//        
////        self.tableView.reloadData()
//
//    }
    @IBAction func buscaButton(_ sender: Any) {
 
//        let search = Models().findResult(busca: searchBar.text!, type:"users")
//         print(search)
//        if search == 0 {
//        searchBar.barTintColor = UIColor.red
//        } else {
//            print("SEARCH = 1")
//            }


        if self.URLString != nil {
            self.URLString = ""
            self.imageURLArray = []
            self.nameArray = []
        }
        
        if !searchBar.text!.isEmpty {
//        self.busca = searchBar.text!
        
            self.busca = searchBar.text!.replacingOccurrences(of: " ", with: "+")
    print("busca acionada:")
            print(self.busca)
            
            
            searchBar.barTintColor = UIColor.black
        let busca = "repositories" //quando botao de buscar usuario for acionado
       
        self.URLString = "https://api.github.com/search/\(busca)?q=\(self.busca)"
        
        print(self.URLString)
        self.downloadJsonWithURL()
        } else {
            print("busca vazia")
            searchBar.tintColor = UIColor.red
            searchBar.barTintColor = UIColor.red
            
//            userTxt.attributedPlaceholder=NSAttributedString(string:"Usuário", attributes: [NSForegroundColorAttributeName:UIColor.red])
     }
    }
    
    func downloadJsonWithURL(){
    
      let url = NSURL(string: self.URLString)
        print (url)
        URLSession.shared.dataTask(with: url as! URL, completionHandler: {(data, response, error) -> Void in
                    print("entrou1")
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                print("entrou: TODO O JSON:")
//                print(jsonObj)
                if let reposArray = jsonObj!.value(forKey: "items") as? NSArray {  // acessa to o JSON
                    print("dados de ITEMS deste JSON:")
                    print(reposArray) //userArray: cada objeto retornado pela busca, dentro dele contem as informações de cada um.
                     //para acessar o nome:
                    for user in reposArray { //para cada resultado, ele vai entrar e pegar os dados:
                        
                        if let userDict = user as? NSDictionary{
                                print("userDict")
                                print(userDict)
//                            if let name = userDict.value(forKey: "name"){
//                                print ("usuario especificado")
//                                print(name)
//                             self.nameArray.append(name as! String)
                            if let name = userDict.value(forKey: "language"){
                                print ("Linguagem utilizada")
                                print(name)
                                self.nameArray.append(name as! String)
//                               // print("DATA:")
//                              //  print(data)
                            } //atualizaTableView?  
            // pega os dados do OWNER:
                            if let owner = userDict.value(forKey: "owner"){
                                print("OWNER")
                                print((owner as AnyObject).value(forKey: "login"))
                                if let login = (owner as AnyObject).value(forKey: "login"){
                                    self.ownerArray.append(login as! String)
                                }
//                                self.ownerArray.append((owner as AnyObject) as! String)
                            }
                            
                            
                            
                             }} //acho que a Tbview tem que atualizar aqui na verdade ...
                  
//                 print ("tentando o OWNER")
//                    print(self.ownerArray)
                    
                        
                    
                }
            }
        
        }).resume()
    }
    
    

    
    //tableview
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return self.ownerArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1") as! TableViewCellSearch
        
        cell.userNameLabel.text = self.ownerArray[indexPath.row]
        
//        let imageURL = NSURL(string: self.imageURLArray[indexPath.row])
//        if imageURL != nil {
//        let data = NSData(contentsOf: (imageURL as? URL)!)
//        cell.avatarUserImage.image = UIImage(data: data as! Data)
//        }

        // inincialmente a tableview is nil
//        }
        return cell
    }
    
    
    
    
    
}
