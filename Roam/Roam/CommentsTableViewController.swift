//
//  CommentsTableViewController.swift
//  Roam
//
//  Created by Samuel Fox on 11/28/18.
//  Copyright © 2018 sof5207. All rights reserved.
//

import UIKit

class CommentsTableViewController: UITableViewController {

    var comments = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let selection = UISelectionFeedbackGenerator()
        selection.selectionChanged()
    }

    // MARK: - Table view data source
    func configure(_ comments: [String]) {
        self.comments = comments
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Comment", for: indexPath)

        cell.textLabel?.text = comments[indexPath.row]

        return cell
    }

}
