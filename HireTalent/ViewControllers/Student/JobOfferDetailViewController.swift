//
//  JobOfferDetailViewController.swift
//  HireTalent
//
//  Created by Ricardo Luna Guerrero on 09/05/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import UIKit

class JobOfferDetailViewController: UIViewController {

    var jobOffer = JobOffer()
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var jobDescriptionLabel: UILabel!
    @IBOutlet weak var vacantsTextField: UITextField!
    @IBOutlet weak var salaryTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var experienceTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupElements()
        initJobOffer()
    }
    
    // Initialize the elements
    func setupElements(){
        
        // Stylize the elements
        Utilities.styleDisplayTextField(jobTitleTextField)
        Utilities.styleDisplayLabel(jobDescriptionLabel)
        Utilities.styleDisplayTextField(vacantsTextField)
        Utilities.styleDisplayTextField(salaryTextField)
        Utilities.styleDisplayTextField(startDateTextField)
        Utilities.styleDisplayTextField(endDateTextField)
        Utilities.styleDisplayTextField(experienceTextField)
        
        // Make the TextFields not editable
        jobTitleTextField.isUserInteractionEnabled = false
        vacantsTextField.isUserInteractionEnabled = false
        salaryTextField.isUserInteractionEnabled = false
        startDateTextField.isUserInteractionEnabled = false
        endDateTextField.isUserInteractionEnabled = false
        experienceTextField.isUserInteractionEnabled = false
        
        // Descripton text field must have multiline
    }

    
    func initJobOffer(){
        jobTitleTextField.text = jobOffer.jobTitle
        jobDescriptionLabel.text = jobOffer.jobDescription
        vacantsTextField.text = String(jobOffer.vacants)
        salaryTextField.text = String(jobOffer.salary)
        startDateTextField.text = jobOffer.startDate
        endDateTextField.text = jobOffer.endDate
        experienceTextField.text = String(jobOffer.experience)
        
    }

}
