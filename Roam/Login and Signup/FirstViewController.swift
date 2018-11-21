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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Roam"
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "AlreadySignedInSegue", sender: nil)
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "SignUpSegue":
            let controller = segue.destination as! SignUpViewController
            
        default:
            assert(false, "Unhandled Segue")
        }
    }
    

}
