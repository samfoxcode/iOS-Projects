//
//  FirstViewController.swift
//  Roam
//
//  Created by Samuel Fox on 11/4/18.
//  Copyright © 2018 sof5207. All rights reserved.
//

import UIKit
import FirebaseAuth

class FirstViewController: UIViewController {
    
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Roam"
        _ = PostsModel.sharedInstance
        loginButton.layer.cornerRadius = 4.0
        signupButton.layer.cornerRadius = 4.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(dataLoaded), userInfo: nil, repeats: false)
        }
    }
    
    @objc func dataLoaded() {
        self.performSegue(withIdentifier: "AlreadySignedInSegue", sender: nil)
    }

}
