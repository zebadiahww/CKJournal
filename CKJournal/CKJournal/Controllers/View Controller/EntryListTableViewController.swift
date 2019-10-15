//
//  EntryListTableViewController.swift
//  CKJournal
//
//  Created by Zebadiah Watson on 10/14/19.
//  Copyright © 2019 Zebadiah Watson. All rights reserved.
//

import UIKit

class EntryListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        EntryController.shared.fetchEntries { (success) in
            if success {
                self.updateViews()
            }
        }
    }

    // MARK: - Table view data source
    
    func updateViews() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return EntryController.shared.entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)
        
        let entry = EntryController.shared.entries[indexPath.row]
        cell.textLabel?.text = entry.titleText

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entryToDelete = EntryController.shared.entries[indexPath.row]
            EntryController.shared.removeEntry(entry: entryToDelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            guard let indexPathEntryDetailCell = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? EntryDetailViewController else { return }
            
            let objectToSend = EntryController.shared.entries[indexPathEntryDetailCell.row]
            
            destinationVC.entryReceiver = objectToSend
        }
    }
    
} // END OF CLASS
