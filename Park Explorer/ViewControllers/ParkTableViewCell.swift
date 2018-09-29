//
//  ParkTableViewCell.swift
//  Park Explorer
//
//  Created by Samuel Fox on 9/29/18.
//  Copyright © 2018 Samuel Fox. All rights reserved.
//

import UIKit

class ParkTableViewCell: UITableViewCell {

    @IBOutlet var captionTextView: UITextView!
    @IBOutlet var parkImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
