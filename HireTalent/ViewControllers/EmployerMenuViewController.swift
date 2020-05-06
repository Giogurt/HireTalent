//
//  EmployerMenuViewController.swift
//  HireTalent
//
//  Created by Ricardo Luna Guerrero on 25/04/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import UIKit
import FirebaseAuth

class EmployerMenuViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfColumns: Int = 1
        
        return numberOfColumns
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows: Int = 4
        
        return numberOfRows
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath.row){
        case 0:
            performSegue(withIdentifier: "myProfile", sender: nil)
        case 1:
            performSegue(withIdentifier: "newJobOffer", sender: nil)
        case 2:
            performSegue(withIdentifier: "myJobOffers", sender: nil)
        case 3:
            performSegue(withIdentifier: "logout", sender: nil)
        default:
            break
        }
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logout" {
            do {
                try Auth.auth().signOut()
            } catch let signOutError as NSError {
              print ("Error signing out: %@", signOutError)
            }
        }
    }

}
