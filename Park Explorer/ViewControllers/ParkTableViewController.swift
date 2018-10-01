//
//  ParkTableViewController.swift
//  Park Explorer
//
//  Created by Samuel Fox on 9/28/18.
//  Copyright © 2018 Samuel Fox. All rights reserved.
//

import UIKit

class ParkTableViewController: UITableViewController, ZoomDelegate {

    @IBOutlet var parkTableView: UITableView!
    
    let parkModel = Model()
    
    var collapse = false
    var collapseSection = 0
    var collapsedSections = [Int]()
    @IBAction func collapseSectionAction(_ sender: UIButton) {
        if collapsedSections.contains(sender.tag){
            collapsedSections.remove(at: collapsedSections.firstIndex(of: sender.tag)!)
        }
        else {
            collapsedSections.append(sender.tag)
        }
        parkTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return parkModel.lengthOfParks()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ZoomSegue":
            let zoomController = segue.destination as! ParkZoomViewController
            let index = parkTableView.indexPathForSelectedRow!
            let park = parkModel.park(index[0])
            let image = UIImage(named: park+"0\(index[1]+1)")
            zoomController.delegate = self
            zoomController.configure(image!)
        default:
            assert(false, "Unhandled Segue")
        }
    }
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }

}
