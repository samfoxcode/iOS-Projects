//
//  HomeTableViewController.swift
//  
//
//  Created by Samuel Fox on 11/20/18.
//

import UIKit
import Firebase

class HomeTableViewController: UITableViewController, UIGestureRecognizerDelegate {

    fileprivate var ref : DatabaseReference!
    fileprivate var storageRef : StorageReference!
    
    @IBOutlet var homeTableView: UITableView!
    
    let cachedImage = CachedImages()
    var tableViewSwipeUpGesture = UISwipeGestureRecognizer()
    var tableViewSwipeDownGesture = UISwipeGestureRecognizer()
    var posts = [Post]()
    var cachedPosts = [Post]()
    var hideStatusBar = false
    
    let postsModel = PostsModel.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(GlobalUsersTableViewController.didSwipe(_:)))
        swipeUp.direction = UISwipeGestureRecognizer.Direction.up
        swipeUp.delegate = self
        self.homeTableView.addGestureRecognizer(swipeUp)
        self.tableViewSwipeUpGesture = swipeUp
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(GlobalUsersTableViewController.didSwipe(_:)))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        swipeDown.delegate = self
        self.homeTableView.addGestureRecognizer(swipeDown)
        self.tableViewSwipeDownGesture = swipeDown
        
        navigationController?.hidesBarsOnSwipe = true
        
        ref = Database.database().reference()
        storageRef = Storage.storage().reference()
    }

    @objc func didSwipe(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case UISwipeGestureRecognizer.Direction.down:
            hideStatusBar = false
        case UISwipeGestureRecognizer.Direction.up:
            hideStatusBar = true
        default:
            break
        }
        setNeedsStatusBarAppearanceUpdate()
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer.isEqual(self.tableViewSwipeUpGesture) || gestureRecognizer.isEqual(self.tableViewSwipeDownGesture) ? true : false
    }
    
    override var prefersStatusBarHidden: Bool {
        return hideStatusBar
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Let's GOOOOOO!!!!!")
        
        postsModel.findFollowingPosts()
        postsModel.refreshContent(for: self.tableView, with: self.refreshControl)

        super.viewWillAppear(animated)
    }
    

    
    
    @IBAction func refreshContent(_ sender: UIRefreshControl) {
        postsModel.findFollowingPosts()
        postsModel.refreshContent(for: self.tableView, with: self.refreshControl)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return postsModel.cachedFollowingPostsCount
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section > 0 {
            return 2.5
        }
        else {
            return 0.0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        
        let imagePath = postsModel.imagePathForFollowingPost(indexPath.section)
        
        let post = postsModel.postForFollowingSection(indexPath.section)
        postsModel.downloadFollowingImage(indexPath, imagePath, post.postID)

        cell.globalPostImageView.image = postsModel.getCachedImage(post.postID)
        cell.post = post
        cell.globalPostExperienceDetails.tag = indexPath.section
        cell.viewCommentsButton.tag = indexPath.section
        cell.unfollowButton.layer.cornerRadius = 4.0
        return cell
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showHomeDetails":
            let button = sender as? UIButton
            let experienceDetailController = segue.destination as! PostExperienceDetailsTableViewController
            let postIndex = button!.tag
            let post = postsModel.postForFollowingSection(postIndex)
            self.navigationController?.navigationBar.isHidden = false
            experienceDetailController.configure(post.travels, post.experiences)
        case "showHomeComments":
            let button = sender as? UIButton
            let index = button!.tag
            let postID = postsModel.postForFollowingSection(index).postID
            let commentsViewController = segue.destination as! CommentsTableViewController
            var comments = [String]()
            self.ref.child(FirebaseFields.Posts.rawValue).child(postID).child("Comments").observe(.value) { (snapshot) in
                for comment in snapshot.children {
                    let _comment = (comment as? DataSnapshot)?.value as! String
                    comments.append(_comment)
                }
                commentsViewController.configure(comments)
            }
        default:
            assert(false, "Unhandled Segue")
        }
    }

}
