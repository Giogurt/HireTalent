//
//  StudentMenuViewController.swift
//  HireTalent
//
//  Created by Ricardo Luna Guerrero on 06/05/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import UIKit
import FirebaseAuth

class StudentMenuViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfSections = 1
        
        return numberOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = 4
        
        return numberOfRows
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch(indexPath.row){
        case 0:
            performSegue(withIdentifier: "studentProfile", sender: nil)
        case 1:
            performSegue(withIdentifier: "viewJobOffers", sender: nil)
        case 3:
            performSegue(withIdentifier: "logoutStudent", sender: nil)
        case 4:
            performSegue(withIdentifier: "deleteStudent", sender: nil)
        default:
            break
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logoutStudent" {
            do {
                try Auth.auth().signOut()
            } catch let signOutError as NSError {
              print ("Error signing out: %@", signOutError)
            }
        }
        
        /*if segue.identifier == "deleteStudent" {
            do {
                try Auth.auth().currentUser?.delete(completion: <#T##UserProfileChangeCallback?##UserProfileChangeCallback?##(Error?) -> Void#>)
            } catch let deleteError as NSError {
                print("Error deleting: %@", deleteError)
            }
        }*/
    }

}
