//
//  EmployerOfferViewController.swift
//  HireTalent
//
//  Created by user168029 on 4/28/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import UIKit

class EmployerOfferViewController: UIViewController,OfferDelegate {
    func updateOfferView(controller: AnyObject, newOffer: JobOffer) {
        loadData()
    }
    

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var salaryLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var experienceLabel: UILabel!
    @IBOutlet weak var vacantslabel: UILabel!

    @IBOutlet var jobDescription:UITextView!
    
    var offer: JobOffer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = offer!.jobTitle
        loadData()
    }

    func loadData(){
        titleLabel.text = offer!.jobTitle
        salaryLabel.text = String(offer!.salary)
        startLabel.text = offer!.startDate
        endLabel.text = offer!.endDate
        experienceLabel.text = String(offer!.experience)
        vacantslabel.text = String(offer!.vacants)
        jobDescription.text = offer!.jobDescription
        
    }
    @IBAction func clickStudentButton(_ sender: UIButton) {
        performSegue(withIdentifier: "interestedStudents", sender: nil)
    }
    @IBAction func editOfferPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "EditOfferSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "interestedStudents" {
            let navigationController = segue.destination as? UINavigationController
            let destinationController = navigationController?.topViewController as! ShowStudentsInOfferViewController
            
            destinationController.students = offer!.interestedStudents
        }
        
        if segue.identifier == "EditOfferSegue"{
            let destination = segue.destination as! EditOfferViewController
            destination.offer = offer
            destination.delegate = self
        }
    }
}
