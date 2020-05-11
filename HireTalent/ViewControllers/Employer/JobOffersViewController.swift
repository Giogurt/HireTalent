//
//  JobOffersViewController.swift
//  HireTalent
//
//  Created by user168029 on 4/26/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import UIKit
import Firebase

class JobOffersViewController: UITableViewController {
    
    let employer = EmployerDAO.getUserId()
    var studentsPerOffer: [Int] = []
    var offers: [JobOffer] = []
    var cellSelected: Int = 0
    
    
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        JobOffersDAO.getOffers(employer) { (error, jobOffers) in
            if error != nil {
                
            } else {
                self.offers = jobOffers!
                self.table.reloadData()
            }
        }
    }

    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfColumns: Int = 1
        return numberOfColumns
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return offers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobOfferCell", for: indexPath) as! JobOffersCell
        
        cell.jobOfferTitle.text = offers[indexPath.row].jobTitle
        cell.numberOfInteresed.text = String(offers[indexPath.row].interestedStudents.count)
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        cellSelected = indexPath.row
        performSegue(withIdentifier: "myOffer", sender: nil)
    }
    
    //This function allow us to pass information between views
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "myOffer" {
            let navigationController = segue.destination as? UINavigationController
            let destinationController = navigationController?.topViewController as! EmployerOfferViewController
            
            destinationController.offer = offers[cellSelected]
        }
    }

}
