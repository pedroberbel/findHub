//
//  TableViewUserRepCell.swift
//  FindHub
//
//  Created by Pedro Luis Berbel dos Santos on 23/02/17.
//  Copyright © 2017 Santosplb. All rights reserved.
//

import UIKit

class TableViewUserRepCell: UITableViewCell {

    
    @IBOutlet weak var repsitoryLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
