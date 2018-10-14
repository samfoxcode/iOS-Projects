//
//  BuildingTableViewCell.swift
//  Campus Walk
//
//  Created by Samuel Fox on 10/14/18.
//  Copyright © 2018 sof5207. All rights reserved.
//

import UIKit

protocol FavoriteDelegate {
    func favoriteBuilding(name:String)
}

class BuildingTableViewCell: UITableViewCell {

    @IBOutlet var favoriteButton: UIButton!
    var delegate : FavoriteDelegate?
    
    @IBAction func favoriteBuilding(_ sender: Any) {
        favoriteButton.isSelected  = favoriteButton.isSelected ? false : true
        print(favoriteButton.restorationIdentifier)
        delegate?.favoriteBuilding(name: favoriteButton.restorationIdentifier!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
