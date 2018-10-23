//
//  TableViewController.swift
//  Campus Walk
//
//  Created by Samuel Fox on 10/14/18.
//  Copyright © 2018 sof5207. All rights reserved.
//

import UIKit

protocol PlotBuildingDelegate {
    func plot(building:String, changeRegion:Bool)
    func favoriteBuilding(name:String)
    func directionsFrom(name:String)
    func directionsTo(name:String)
}

class TableViewController: UITableViewController, FavoriteDelegate {
    
    func favoriteBuilding(name: String) {
        delegate?.favoriteBuilding(name: name)
    }
    func directionsFrom(name: String) {
        delegate?.directionsFrom(name: name)
    }
    func directionsTo(name: String) {
        delegate?.directionsTo(name: name)
    }
    
    let mapModel = CampusModel.sharedInstance
    var delegate : PlotBuildingDelegate?
    var favorites = [String]()
    var directionsRequest = false
    var direction = ""
    @IBOutlet var buildingTableView: UITableView!
    @IBAction func cancelSearch(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.title = "Campus Buildings"
        
        buildingTableView.delegate = self
        self.clearsSelectionOnViewWillAppear = true
    

    }

    func configure(_ namesOfFavorites : [String], _ sender: Any?){
        self.favorites = namesOfFavorites
        if sender is String {
            directionsRequest = true
            direction = sender as! String
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return mapModel.numberOfKeys
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mapModel.numberOfBuildingsForKey(section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "building", for: indexPath) as! BuildingTableViewCell
        let buildingName = mapModel.buildingName(at: indexPath)
        cell.textLabel?.text = buildingName
        cell.favoriteButton.restorationIdentifier = buildingName
        cell.delegate = self
        if favorites.contains(buildingName) {
            cell.favoriteButton.isSelected = true
            print("TRUE")
        }
        else {
            cell.favoriteButton.isSelected = false
        }

        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let building = mapModel.buildingName(at: indexPath)
        dismiss(animated: true, completion: nil)
        if direction == "FROM" {
            delegate?.directionsFrom(name: building)
            return
        }
        if direction == "TO" {
            delegate?.directionsTo(name: building)
            return
        }
        delegate?.plot(building: building, changeRegion: true)
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return mapModel.buildingIndexTitles
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mapModel.buildingIndexTitles[section]
    }
    
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

}
