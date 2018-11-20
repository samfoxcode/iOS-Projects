//
//  SignUpViewController.swift
//  Roam
//
//  Created by Samuel Fox on 11/4/18.
//  Copyright © 2018 sof5207. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var newUserEmail: UITextField!
    @IBOutlet weak var newUserPassword: UITextField!
    @IBOutlet weak var confirmNewUserPassword: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newUserEmail.delegate = self
        newUserPassword.delegate = self
        confirmNewUserPassword.delegate = self
    }
    
    @IBAction func registerUser(_ sender: Any) {
        Auth.auth().createUser(withEmail: newUserEmail.text!, password: newUserPassword.text!) { (user, error) in
            if error == nil {
                self.performSegue(withIdentifier: "SignupToHomeSegue", sender: self)
            }
            else{
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let cancelAlert = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(cancelAlert)
                self.present(alertController, animated: true)
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard (!(textField.text?.isEmpty)!) else {return false}
        
        textField.endEditing(true)
        return true
    }
    
    func processErrors(_ textField: UITextField) {
        
    }
    
    func processSuccess(_ textField: UITextField) {
        
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
