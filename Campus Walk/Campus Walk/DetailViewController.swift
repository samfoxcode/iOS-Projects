//
//  DetailViewController.swift
//  Campus Walk
//
//  Created by Samuel Fox on 10/21/18.
//  Copyright © 2018 sof5207. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var buildingImageView: UIImageView!
    @IBOutlet var buildingLabel: UILabel!
    
    var image : UIImage?
    var buildingText = String()
    
    @IBAction func doneAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if image != nil {
            buildingImageView.image = image
        }
        buildingLabel.text = buildingText
    }
    
    func configure(_ image : UIImage, _ text : String) {
        self.image = image
        self.buildingText = text
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
