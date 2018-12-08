//
//  ProfileCollectionViewCell.swift
//  Roam
//
//  Created by Samuel Fox on 11/21/18.
//  Copyright © 2018 sof5207. All rights reserved.
//

import UIKit
import Firebase
class ProfileCollectionViewCell: UICollectionViewCell {
    
    fileprivate var storageRef : StorageReference!
    fileprivate var downloadImageTask : StorageDownloadTask!
    fileprivate var databaseRef : DatabaseReference!
    
    
    @IBOutlet weak var postImageView: UIImageView!
    var post: Post? {
        didSet {
            if let post = post {
                if postImageView.image == nil {
                    downloadImage(from: post.imagePath[0])
                }
            }
        }
    }
    
    func downloadImage(from imagePath: String) {
        let storage = storageRef.storage.reference(forURL: imagePath)
        storage.getData(maxSize: 2*1024*1024) { (data, error) in
            if error == nil {
                self.postImageView.image = UIImage(data: data!)
            }
            else {
                print("Error:\(error ?? "" as! Error)")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        storageRef = Storage.storage().reference()
        databaseRef = Database.database().reference()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postImageView.image = nil
    }
    
}
