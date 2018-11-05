//
//  PostTableViewCell.swift
//  
//
//  Created by Samuel Fox on 11/4/18.
//

import UIKit
import Firebase

class PostTableViewCell: UITableViewCell {

    fileprivate var storageRef : StorageReference!
    fileprivate var downloadImageTask : StorageDownloadTask!
    
    @IBOutlet weak var globalPostersName: UILabel!
    @IBOutlet weak var globalPosterUsername: UILabel!
    @IBOutlet weak var globalPostImageView: UIImageView!
    @IBOutlet weak var globalPostExperienceDetails: UIButton!
    @IBOutlet weak var globalPostFavButton: UIButton!
    @IBOutlet weak var globalPostDescriptionTextView: UITextView!
    @IBOutlet weak var globalCommentTextView: UITextView!
    
    var post: Post? {
        didSet {
            if let post = post {
                downloadImage(from: post.imagePath)
                globalPostersName.text = post.addedByUser
                globalPosterUsername.text = post.username
                globalPostDescriptionTextView.text = "Testing TextView Text"
                globalCommentTextView.text = "Leave a comment"
            }
        }
    }
    
    
    func downloadImage(from imagePath: String) {
        let storage = storageRef.storage.reference(forURL: imagePath)
        storage.getData(maxSize: 1*1024*1024) { (data, error) in
            if error == nil {
                self.globalPostImageView.image = UIImage(data: data!)
            }
            else {
                print("Error:\(error ?? "" as! Error)")
            }
        }
        
        
        /*
        
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let filePath = "file:\(documentsDirectory)/myimage.jpg"
        guard let fileURL = URL(string: filePath) else { return }
        
        downloadImageTask = storageRef.child(imagePath).write(toFile: fileURL, completion: { (url, error) in
            if let error = error {
                print("Error downloading:\(error)")
                return
            } else if let imagePath = url?.path {
                self.globalPostImageView.image = UIImage(contentsOfFile: imagePath)
            }
        })
         */
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        storageRef = Storage.storage().reference()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        globalPostImageView.image = nil
        globalPostersName.text = ""
        globalPosterUsername.text = ""
    }
}
