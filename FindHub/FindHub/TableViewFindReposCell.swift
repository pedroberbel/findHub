//
//  TableViewFindReposCell.swift
//  FindHub
//
//  Created by Pedro Luis Berbel dos Santos on 24/02/17.
//  Copyright © 2017 Santosplb. All rights reserved.
//

import UIKit

class TableViewFindReposCell: UITableViewCell {
  
    //outlets inside of the tableView Cell with information of the searched repositories
    @IBOutlet weak var ownerLoginLabel: UILabel!
    @IBOutlet weak var repositoryNameLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
