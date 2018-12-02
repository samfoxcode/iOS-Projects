//
//  ProfileViewController.swift
//  Roam
//
//  Created by Samuel Fox on 11/5/18.
//  Copyright © 2018 sof5207. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, MainViewDelegate {
    
    fileprivate var ref : DatabaseReference!
    fileprivate var storageRef : StorageReference!
    
    @IBOutlet weak var profileNavBar: UINavigationBar!
    @IBOutlet weak var profileCollectionView: UICollectionView!
    var collectionToShow = "UsersPosts"
    //let cachedImage = CachedImages()
    //var posts = [Post]()
    //var cachedPosts = [Post]()
    var pageTitle = String()
    
    let postModel = PostsModel.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileCollectionView.dataSource = self
        profileCollectionView.delegate = self
        
        ref = Database.database().reference()
        storageRef = Storage.storage().reference()
        
        //profileNavBar.topItem?.title = pageTitle
        // Do any additional setup after loading the view.
    }
    
    func toggleCollectionViewType(show collection: String) {
        let selection = UISelectionFeedbackGenerator()
        selection.selectionChanged()
        self.collectionToShow = collection
        profileCollectionView.reloadData()
    }
    
    /*
    func downloadImage(_ indexPath: IndexPath, _ imageURL: String) {
        let storage = storageRef.storage.reference(forURL: cachedPosts[indexPath.row].imagePath)
        storage.getData(maxSize: 2*1024*1024) { (data, error) in
            if error == nil {
                //self.cachedPosts[indexPath.section].cachedImage = UIImage(data: data!)
                let image = UIImage(data: data!)
                self.cachedImage.cacheImage(imageURL, image!)
            }
            else {
                print("Error:\(error ?? "" as! Error)")
            }
        }
    }
    */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.refreshControl?.attributedTitle = NSAttributedString(string: "Let's GOOOOOO!!!!!")
        super.viewWillAppear(animated)
        postModel.findUsersPosts()
        postModel.findBookmarkedPosts()
        self.profileCollectionView.reloadData()
        //var account : NewUser?
        /*
        if Auth.auth().currentUser != nil {
            ref.child(FirebaseFields.Accounts.rawValue).child(Auth.auth().currentUser!.uid).observe(.value) { (snapshot) in
                
                let user = NewUser(snapshot: snapshot)
                self.pageTitle = user.firstname
                //self.profileNavBar.topItem?.title = self.pageTitle
                
                self.ref.child(FirebaseFields.Posts.rawValue).observe(.value) { (snapshot) in
                    var posts = [Post]()
                    for postSnapshot in snapshot.children {
                        let post = Post(snapshot: postSnapshot as! DataSnapshot)
                        if post.username == user.username {
                            posts.append(post)
                        }
                    }
                    self.posts = posts
                    let block = {
                        self.cachedPosts = self.posts.reversed()
                        self.profileCollectionView.reloadData()
                    }
                    DispatchQueue.main.async(execute: block)
                }
            }
        }
         */
    }
    
    /*
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ProfileHeader", for: indexPath) as! ProfileHeaderCollectionViewCell
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            if indexPath.section == 0 {
     
            }
            return cell
            
        default:
            assert(false, "Unexpected Cell")
        }
        
        return cell
    }
    */
    
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionToShow == "UsersPosts" {
            print("USERSPOSTS")
            return postModel.cachedUsersPostsCount
        }
        else {
            print("BOOKMARKEDPOSTS")
            return postModel.cachedBookmarkedPostsCount
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as! ProfileCollectionViewCell
        
        /*
        downloadImage(indexPath, cachedPosts[indexPath.row].imagePath)
        cell.postImageView.image = cachedImage.getCachedImage(cachedPosts[indexPath.row].imagePath)
        cell.post = self.cachedPosts[indexPath.row]
        */
        
        if collectionToShow == "BookmarkedPosts"{
            let imagePath = postModel.imagePathForBookmarkedPost(indexPath.row)
            let post = postModel.postForBookmarkedSection(indexPath.row)
            
            postModel.downloadBookmarkedImage(indexPath.row, imagePath, post.postID)
            cell.postImageView.image = postModel.getCachedImage(post.postID)
        }
        else {
            let imagePath = postModel.imagePathForUsersPost(indexPath.row)
            let post = postModel.postForUsersSection(indexPath.row)
            
            postModel.downloadUsersPostImage(indexPath.row, imagePath, post.postID)
            cell.postImageView.image = postModel.getCachedImage(post.postID)
        }
        return cell
    }
    
}

