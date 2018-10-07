//
//  ContentViewController.swift
//  Park Explorer
//
//  Created by Samuel Fox on 10/7/18.
//  Copyright © 2018 Samuel Fox. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {
    
    @IBOutlet var demoImageView: UIImageView!
    
    
    var demoImage : UIImage?
    var pageIndex : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        demoImageView.image = demoImage
        
    }
    
    func configure(_ image : UIImage) {
        demoImage = image
    }
    
}
