//
//  ParkTableViewController.swift
//  Park Explorer
//
//  Created by Samuel Fox on 9/28/18.
//  Copyright © 2018 Samuel Fox. All rights reserved.
//

import UIKit

class ParkTableViewController: UITableViewController {

    @IBOutlet var parkTableView: UITableView!
    
    let parkModel = Model.sharedInstance
    let scrollViewManager = ScrollViewManager()
    var collapse = false
    var collapseSection = 0
    var collapsedSections = [Int]()
    var count = 0
    var detailViewController: ParkImageViewController? = nil
    
    @IBAction func collapseSectionAction(_ sender: UIButton) {
        if collapsedSections.contains(sender.tag){
            collapsedSections.remove(at: collapsedSections.firstIndex(of: sender.tag)!)
        }
        else {
            collapsedSections.append(sender.tag)
        }
        parkTableView.reloadSections(IndexSet(integersIn: 0..<parkModel.lengthOfParks()), with: UITableView.RowAnimation.automatic)
        parkTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parkTableView.scrollsToTop = true
        
        if let split = splitViewController {
            split.presentsWithGesture = true
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? ParkImageViewController
        }
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if count < 1 {
        performSegue(withIdentifier: "ShowDemo", sender: self.view)
        }
        count = count + 1
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return parkModel.lengthOfParks()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if collapsedSections.contains(section) {
            return 0
        }
        else {
            return parkModel.parkInfoLength(section)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParkHeaderCell") as! HeaderTableViewCell
        cell.headerButton.setTitle(parkModel.park(section), for: .normal)
        cell.headerButton.tag = section
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParkCell", for: indexPath) as! ParkTableViewCell
        let parkName = parkModel.park(indexPath.section)
        let parkImageName = parkName+"0\(indexPath.row+1)"
        let parkImage = UIImage(named: parkImageName)
        cell.parkImageView.image = parkImage
        cell.captionTextView.text = parkModel.parkCaption(indexPath.section, indexPath.row, parkImageName)
        return cell
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ZoomSegue", sender: tableView)
    }
    
 
     override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if (scrollViewManager.parkImageGlobal != nil) {
            scrollViewManager.scrollViewTransitionUpdate(size, self.view)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ZoomSegue":
            let navController = segue.destination as! UINavigationController
            let parkImageController =  navController.topViewController! as! ParkImageViewController
            
            let indexPath = parkTableView.indexPathForSelectedRow!
            let parkName = parkModel.park(indexPath.section)
            let parkImageName = parkName+"0\(indexPath.row+1)"
            let parkImage = UIImage(named: parkImageName)
            let caption = parkModel.parkCaption(indexPath.section, indexPath.row, parkImageName)
            
            parkImageController.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            parkImageController.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
            parkImageController.navigationItem.leftItemsSupplementBackButton = true
            
            
            parkImageController.configure(parkImage!, caption, parkName)
            parkTableView.deselectRow(at: indexPath, animated: true)
        case "ShowDemo":
            return
        default:
            assert(false, "Unhandled Segue")
        }
    }

}
