//
//  FlightsStaysTableViewController.swift
//  
//
//  Created by Samuel Fox on 11/8/18.
//

import UIKit

protocol TravelDelegate {
    func saveTravels(_ travels: [String])
}

class FlightsStaysTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet var travelTableView: UITableView!
    var isAdding = false
    var delegate: TravelDelegate?
    let model = TravelInfo.sharedTravelsInstance
    
    struct TaskSection {
        static let tasks = 0
        static let add = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func doneAdding(_ sender: Any) {
        delegate?.saveTravels(model.travels)
        model.travels = [String]()
        dismiss(animated: true, completion: nil)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(UINotificationFeedbackGenerator.FeedbackType.success)
    }
    
    @IBAction func addTravel(_ sender: Any) {
        isAdding = !isAdding
        travelTableView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        isAdding = false
        
        guard let text = textField.text else {return true}
        
        if text.isEmpty {
            tableView.reloadData()
        }
        else {
            model.addTravel(text)
            textField.text = ""
            tableView.reloadData()
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(UINotificationFeedbackGenerator.FeedbackType.success)
        }
        return true
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return isAdding ? 2 : 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case TaskSection.tasks:
            return model.travelsCount
        case TaskSection.add:
            return 1
        default:
            assert(false, "Unhandled Section Number")
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case TaskSection.tasks:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Travel", for: indexPath)
            cell.textLabel?.text = model.travelAtIndex(indexPath.row)
            return cell
        case TaskSection.add:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddTravel", for: indexPath) as! ExperienceTableViewCell
            return cell
        default:
            assert(false, "Unhandled Section Number")
        }
        return tableView.dequeueReusableCell(withIdentifier: "Travel", for: indexPath)
    }
    
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete"
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            model.deleteTravelAtIndex(indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return false
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
