//
//  EmployerOfferViewController.swift
//  HireTalent
//
//  Created by user168029 on 4/28/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import UIKit

class EmployerOfferViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    var offer: JobOffer = JobOffer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = offer.jobTitle
        titleLabel.text = self.offer.jobTitle
    }

    @IBAction func clickStudentButton(_ sender: UIButton) {
        performSegue(withIdentifier: "interestedStudents", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "interestedStudents" {
            let navigationController = segue.destination as? UINavigationController
            let destinationController = navigationController?.topViewController as! ShowStudentsInOfferViewController
            
            destinationController.students = offer.interestedStudents
        }
    }
}
