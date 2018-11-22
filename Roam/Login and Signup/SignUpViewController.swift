//
//  SignUpViewController.swift
//  Roam
//
//  Created by Samuel Fox on 11/4/18.
//  Copyright © 2018 sof5207. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var newUserEmail: UITextField!
    @IBOutlet weak var newUserPassword: UITextField!
    @IBOutlet weak var confirmNewUserPassword: UITextField!
    @IBOutlet weak var newUserUsername: UITextField!
    @IBOutlet weak var newUserFirstName: UITextField!
    @IBOutlet weak var newUserLastName: UITextField!
    
    fileprivate var ref : DatabaseReference!
    var keyboardVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newUserFirstName.delegate = self
        newUserLastName.delegate = self
        newUserUsername.delegate = self
        newUserEmail.delegate = self
        newUserPassword.delegate = self
        confirmNewUserPassword.delegate = self
        ref = Database.database().reference()
        self.title = "Signup for Roam!"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name:
            UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func registerUser(_ sender: Any) {
        Auth.auth().createUser(withEmail: newUserEmail.text!, password: newUserPassword.text!) { (user, error) in
            if error == nil {
                
                let firstname = self.newUserFirstName.text!
                let lastname = self.newUserLastName.text!
                let username = self.newUserUsername.text!
                let email = user?.email
                let userId = user?.uid
                let newUser = NewUser(firstname: firstname, lastname: lastname, username: username, uid: userId!, email: email!)
                
                self.ref.child("Accounts").child(userId!).setValue(newUser.toObject());
                
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
    
    @objc func keyboardWillShow(notification:Notification) {
        if !keyboardVisible && ( self.view.traitCollection.horizontalSizeClass != UIUserInterfaceSizeClass.regular ) {
            let userInfo = notification.userInfo!
            let keyboardSize = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect
            if self.view.frame.origin.y == 0 && (newUserPassword.isEditing || confirmNewUserPassword.isEditing) {
                self.view.frame.origin.y -= keyboardSize!.height/4
            }
        }
        
        keyboardVisible = true
    }
    
    @objc
    func keyboardWillHide(notification:Notification) {
        if keyboardVisible && ( self.view.traitCollection.horizontalSizeClass != UIUserInterfaceSizeClass.regular ) {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y = 0
            }
        }
        keyboardVisible = false
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