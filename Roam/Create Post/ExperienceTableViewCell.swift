//
//  ExperienceTableViewCell.swift
//  Roam
//
//  Created by Samuel Fox on 11/10/18.
//  Copyright © 2018 sof5207. All rights reserved.
//

import UIKit

class ExperienceTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var experienceTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
