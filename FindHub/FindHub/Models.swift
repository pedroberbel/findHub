//
//  Models.swift
//  FindHub
//
//  Created by Pedro Luis Berbel dos Santos on 24/02/17.
//  Copyright © 2017 Santosplb. All rights reserved.
//

import UIKit

class Models{
    
    
    var URLString: String?
    var nameArray = [String]()
    var imageURLArray = [String]()
    
    
    
    

    
    func findResult(busca:String, type:String){
        
        if self.URLString != nil {
            self.URLString = nil
            self.imageURLArray = []
            self.nameArray = []
        }
        //tem que ser resolvida na tela que chama a função e que tem a search Bar:
        if !busca.isEmpty { //trocar pelo valor de entrada da funçao
//            self.busca = searchBar.text!
        
            print("busca acionada")
//            searchBar.barTintColor = UIColor.black
         
            var tipoBusca = type //quando botao de buscar usuario for acionado
            
            self.URLString = "https://api.github.com/search/\(tipoBusca)?q=\(busca)"
            
            print(self.URLString)
            
           self.downloadJsonWithURLfromModel()
        
            
        } else {
            print("busca vazia")
            
        }
        
        }
    
    
    func loadRepoUser() {
        
    }
    
    func loadUsersRepository() {
        
        
    }
    
    func downloadJsonWithURLfromModel(){
        
        let url = NSURL(string: self.URLString!)
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
                                
                                // print("DATA:")
                                //  print(data)
                            }
                            if let image = userDict.value(forKey: "avatar_url"){
                                self.imageURLArray.append(image as! String)
                                
                            }
                            
//                            let a = FindUserViewController()
//                            a.gVariables(self.nameArray, self.imageURLArray, self.nameArray.count)
//                           print("Enviou os dados")
                            
                            
//                            OperationQueue.main.addOperation {
//                                a.tableView.reloadData()
//                            self.tableView.reloadData()
//                            }
//                                self.tableView.reloadData()
//                                print("ATUALIZOU A TABELA")
//                            }
                        
                        }
                    }
                }
            }
            
        }).resume()
//        print("valores afinal:")
//        print(self.nameArray)
        
    }
    

    
    
}
