//
//  ViewController.swift
//  Roam
//
//  Created by Samuel Fox on 11/3/18.
//  Copyright © 2018 sof5207. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    fileprivate var ref : DatabaseReference!
    fileprivate var storageRef : StorageReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        //ref.child("Users").child("UniqueId").setValue(["addedBy":"ME", "imagePath":"TestPath"])
        
        storageRef = Storage.storage().reference()
    }


}

