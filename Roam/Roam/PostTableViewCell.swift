//
//  PostTableViewCell.swift
//  
//
//  Created by Samuel Fox on 11/4/18.
//

import UIKit
import Firebase

class PostTableViewCell: UITableViewCell, UITextViewDelegate {

    fileprivate var storageRef : StorageReference!
    fileprivate var downloadImageTask : StorageDownloadTask!
    fileprivate var databaseRef : DatabaseReference!
    
    @IBOutlet weak var globalPostersName: UILabel!
    @IBOutlet weak var globalPosterUsername: UILabel!
    @IBOutlet weak var globalPostImageView: UIImageView!
    @IBOutlet weak var globalPostExperienceDetails: UIButton!
    @IBOutlet weak var globalPostFavButton: UIButton!
    @IBOutlet weak var globalPostDescriptionTextView: UITextView!
    @IBOutlet weak var globalCommentTextView: UITextView!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var unfollowButton: UIButton!
    @IBOutlet weak var viewCommentsButton: UIButton!
    
    
    var postID = String()
    
    var post: Post? {
        didSet {
            if let post = post {
                if globalPostImageView.image == nil {
                    downloadImage(from: post.imagePath)
                }
                globalPostersName.text = post.addedByUser
                globalPosterUsername.text = post.username
                globalPostDescriptionTextView.text = post.description
                globalCommentTextView.text = "Leave a comment"
                postID = post.postID
            }
        }
    }
    
    
    func downloadImage(from imagePath: String) {
        let storage = storageRef.storage.reference(forURL: imagePath)
        storage.getData(maxSize: 2*1024*1024) { (data, error) in
            if error == nil {
                self.globalPostImageView.image = UIImage(data: data!)
            }
            else {
                print("Error:\(error ?? "" as! Error)")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        globalCommentTextView.delegate = self
        globalCommentTextView.returnKeyType = .done
        storageRef = Storage.storage().reference()
        databaseRef = Database.database().reference()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.databaseRef.child(FirebaseFields.Posts.rawValue).child(postID).child("Comments").child("\(Int(Date.timeIntervalSinceReferenceDate * 1000))").setValue(textView.text)
        textView.resignFirstResponder()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    @IBAction func bookmarkPost(_ sender: Any) {
        let currentUser = databaseRef.child(FirebaseFields.Users.rawValue).child(Auth.auth().currentUser!.uid)
        currentUser.child("Bookmarks").child(postID).setValue(true)
        let selection = UISelectionFeedbackGenerator()
        selection.selectionChanged()
    }
    
    
    @IBAction func followUser(_ sender: UIButton) {
        if sender.titleLabel?.text == "Follow" {
            let currentUser = databaseRef.child(FirebaseFields.Users.rawValue).child(Auth.auth().currentUser!.uid)
            currentUser.child("following").child(globalPosterUsername!.text!).setValue(true)
        }
        if sender.titleLabel?.text == "Unfollow" {
            let currentUser = databaseRef.child(FirebaseFields.Users.rawValue).child(Auth.auth().currentUser!.uid)
            currentUser.child("following").child(globalPosterUsername!.text!).removeValue()
        }
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(UINotificationFeedbackGenerator.FeedbackType.success)
        //child("\(Int(Date.timeIntervalSinceReferenceDate * 1000))")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        globalPostImageView.image = nil
        globalPostersName.text = ""
        globalPosterUsername.text = ""
    }

}
