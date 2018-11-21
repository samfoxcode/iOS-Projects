//
//  ProfileViewController.swift
//  Roam
//
//  Created by Samuel Fox on 11/5/18.
//  Copyright © 2018 sof5207. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    fileprivate var ref : DatabaseReference!
    fileprivate var storageRef : StorageReference!
    
    
    @IBOutlet weak var profileNavBar: UINavigationBar!
    @IBOutlet weak var profileCollectionView: UICollectionView!
    
    let cachedImage = CachedImages()
    var posts = [Post]()
    var cachedPosts = [Post]()
    var pageTitle = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileCollectionView.dataSource = self
        profileCollectionView.delegate = self
        
        ref = Database.database().reference()
        storageRef = Storage.storage().reference()
        
        profileNavBar.topItem?.title = pageTitle
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        }
        catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initial = storyboard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = initial
    }
    
    func downloadImage(_ indexPath: IndexPath, _ imageURL: String) {
        let storage = storageRef.storage.reference(forURL: cachedPosts[indexPath.row].imagePath)
        storage.getData(maxSize: 1*1024*1024) { (data, error) in
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
    
    override func viewWillAppear(_ animated: Bool) {
        //self.refreshControl?.attributedTitle = NSAttributedString(string: "Let's GOOOOOO!!!!!")
        //var account : NewUser?
        
        if Auth.auth().currentUser != nil {
            ref.child(FirebaseFields.Accounts.rawValue).child(Auth.auth().currentUser!.uid).observe(.value) { (snapshot) in
                
                let user = NewUser(snapshot: snapshot)
                self.pageTitle = user.firstname
                self.profileNavBar.topItem?.title = self.pageTitle
                
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
        super.viewWillAppear(animated)
    }
    
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cachedPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as! ProfileCollectionViewCell
        
        downloadImage(indexPath, cachedPosts[indexPath.row].imagePath)
        cell.postImageView.image = cachedImage.getCachedImage(cachedPosts[indexPath.row].imagePath)
        cell.post = self.cachedPosts[indexPath.row]

        return cell
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

