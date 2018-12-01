//
//  ExperiencesTableViewController.swift
//  Roam
//
//  Created by Samuel Fox on 11/8/18.
//  Copyright © 2018 sof5207. All rights reserved.
//

import UIKit

protocol ExperiencesDelegate {
    func saveExperiences(_ experiences: [String])
}

class ExperiencesTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet var experiencesTableView: UITableView!
    var isAdding = false
    var delegate: ExperiencesDelegate?
    let model = Experiences.sharedExperiencesInstance
    
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
        
        dismiss(animated: true, completion: nil)
        delegate?.saveExperiences(model.experiences)
    }
    
    @IBAction func addExperience(_ sender: Any) {
        isAdding = !isAdding
        experiencesTableView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        isAdding = false
        
        guard let text = textField.text else {return true}
        
        if text.isEmpty {
            tableView.reloadData()
        }
        else {
            model.addExperience(text)
            textField.text = ""
            tableView.reloadData()
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
            return model.experiencesCount
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "Experience", for: indexPath)
            cell.textLabel?.text = model.experienceAtIndex(indexPath.row)
            return cell
        case TaskSection.add:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddExperience", for: indexPath) as! ExperienceTableViewCell
            return cell
        default:
            assert(false, "Unhandled Section Number")
        }
        return tableView.dequeueReusableCell(withIdentifier: "Experience", for: indexPath)
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
            model.deleteExperienceAtIndex(indexPath.row)
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
