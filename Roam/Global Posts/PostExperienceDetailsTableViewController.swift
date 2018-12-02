//
//  PostExperienceDetailsTableViewController.swift
//  Roam
//
//  Created by Samuel Fox on 11/11/18.
//  Copyright © 2018 sof5207. All rights reserved.
//

import UIKit

class PostExperienceDetailsTableViewController: UITableViewController {
    
    var travels = [String]()
    var experiences = [String]()
    
    func configure(_ travels: [String], _ experiences: [String]) {
        self.travels = travels
        self.experiences = experiences
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.isNavigationBarHidden = false
        let selection = UISelectionFeedbackGenerator()
        selection.selectionChanged()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return experiences.count
        }
        else if section == 1 {
            return travels.count
        }
        else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Experiences"
        }
        if section == 1 {
            return "Travels"
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Detail", for: indexPath)

        if indexPath.section == 0 {
            cell.textLabel?.text = experiences[indexPath.row]
        }
        if indexPath.section == 1 {
            cell.textLabel?.text = travels[indexPath.row]
        }
        return cell
    }

}
