//
//  TableViewFindUserCell.swift
//  FindHub
//
//  Created by Pedro Luis Berbel dos Santos on 24/02/17.
//  Copyright © 2017 Santosplb. All rights reserved.
//

import UIKit

class TableViewFindUserCell: UITableViewCell {

    //outlets inside of the tableView Cell with information of the searched users
    @IBOutlet weak var avatarUserImage: UIImageView!
    @IBOutlet weak var loginUserLabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        //the avatar imageView with circular design, fixed by clipsToBounds when it load the picture.
        avatarUserImage.clipsToBounds = true
        avatarUserImage.layer.cornerRadius = avatarUserImage.frame.size.width/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
