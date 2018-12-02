//
//  ProfileMainViewController.swift
//  Roam
//
//  Created by Samuel Fox on 12/1/18.
//  Copyright © 2018 sof5207. All rights reserved.
//

import UIKit
import Firebase

protocol MainViewDelegate {
    func toggleCollectionViewType(show collection: String)
}

class ProfileMainViewController: UIViewController {

    var delegate : MainViewDelegate?
    
    
    @IBOutlet weak var profileNavBar: UINavigationBar!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    fileprivate var ref : DatabaseReference!
    var pageTitle = String()
    
    @IBAction func signOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(UINotificationFeedbackGenerator.FeedbackType.success)
        }
        catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(UINotificationFeedbackGenerator.FeedbackType.error)
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initial = storyboard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = initial
    }
    
    @IBAction func segmentControlAction(_ sender: UISegmentedControl) {
        var collection = String()
        if sender.selectedSegmentIndex == 0 {
            collection = "UsersPosts"
        }
        else {
            collection = "BookmarkedPosts"
        }
        delegate?.toggleCollectionViewType(show: collection)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        if Auth.auth().currentUser != nil && pageTitle.count < 1 {
            ref.child(FirebaseFields.Accounts.rawValue).child(Auth.auth().currentUser!.uid).observe(.value) { (snapshot) in
                
                let user = NewUser(snapshot: snapshot)
                self.pageTitle = user.firstname
                self.title = self.pageTitle
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "presentCollectionView":
            let controller = segue.destination as! ProfileViewController
            self.delegate = controller
            
        case "settings":
            _ = segue.destination as! SettingsViewController
        default:
            assert(false, "Unhandled Segue")
        }
    }
    

}
