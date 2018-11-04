//
//  UploadPostViewController.swift
//  
//
//  Created by Samuel Fox on 11/3/18.
//

import UIKit
import Firebase

class UploadPostViewController: UIViewController {

    fileprivate var ref : DatabaseReference!
    fileprivate var storageRef : StorageReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        storageRef = Storage.storage().reference()
        
    }
    
    @IBAction func submitPost(_ sender: Any) {
        let post = Post(addedByUser: "Sam", username: "Samf1596", description: "DescriptionTest", imagePath: "ImagePathTest", flights: "FlightTest", itinerary: "ItineraryTest", stays: "StaysTest", isPublic: true)
        
        ref.child(FirebaseFields.Posts.rawValue).child(post.username + "\(Int(Date.timeIntervalSinceReferenceDate * 1000))").setValue(post.toObject())
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
