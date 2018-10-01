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
    
    @IBAction func collapseSectionAction(_ sender: UIButton) {
        collapse = collapse ? false : true
        collapseSection = sender.tag
        parkTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return parkModel.lengthOfParks()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if collapse && section == collapseSection{
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
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

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
