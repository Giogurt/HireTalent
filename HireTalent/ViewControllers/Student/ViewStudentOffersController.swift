//
//  ViewStudentOffersController.swift
//  HireTalent
//
//  Created by Ricardo Luna Guerrero on 09/05/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import UIKit

class ViewStudentOffersController: UITableViewController {

    var jobOffers: [JobOffer] = []
    var jobOffer: Int = 0
    @IBOutlet var jobOffersTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    func loadData(){
        jobOffers.removeAll()
        JobOffersDAO.getAllJobOffers(){ (jobOffersReturned) in
            
            if jobOffersReturned == nil {
                
            } else {
                for offer in jobOffersReturned!{
                    
                    if offer.open == true{
                        self.jobOffers.append(offer)
                    }
                
                self.jobOffersTable.reloadData()
            }
        }
    }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfSections: Int = 1
        return numberOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return jobOffers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobOfferCell", for: indexPath)
        
        cell.textLabel?.text = jobOffers[indexPath.row].jobTitle
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        jobOffersTable.deselectRow(at: indexPath, animated: true)
        jobOffer = indexPath.row
        if(jobOffers[jobOffer].open){
           performSegue(withIdentifier: "jobOfferDetail", sender: nil)
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "jobOfferDetail" {
            let jobOfferDetail = segue.destination as? JobOfferDetailViewController
            
            jobOfferDetail?.jobOffer = jobOffers[jobOffer]
        }
    }

}
