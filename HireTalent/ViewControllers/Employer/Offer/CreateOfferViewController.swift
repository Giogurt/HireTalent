//
//  CreateOfferViewController.swift
//  HireTalent
//
//  Created by Ricardo Luna Guerrero on 16/04/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import UIKit

class CreateOfferViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var vacantsTextField: UITextField!
    @IBOutlet weak var salaryTextField: UITextField!
    @IBOutlet weak var experienceTextField: UITextField!
    @IBOutlet weak var newOfferButton: UIButton!
    var userId: String = EmployerDAO.getUserId()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Stylize the UI elements
        setUpElements()
        
        // Add the functionality to date pickers
        initDatePickers()
    }
    
    
    // Stylize the UI elements
    func setUpElements() {
        
        // Style the elements
        Utilities.styleFormTextField(titleTextField)
        Utilities.styleFormTextField(startDateTextField)
        Utilities.styleFormTextField(endDateTextField)
        Utilities.styleFormTextField(vacantsTextField)
        Utilities.styleFormTextField(salaryTextField)
        Utilities.styleFormTextField(experienceTextField)
        Utilities.styleFilledButton2(newOfferButton)
    }
    
    
    // Add the functionality to date pickers
    func initDatePickers(){
        self.startDateTextField.setInputViewDatePicker(target: self, selector: #selector(startTapDone))
        self.endDateTextField.setInputViewDatePicker(target: self, selector: #selector(endTapDone))
    }
    
    
    // Display alert
    func displayAlert() {
        let alertController = UIAlertController(title: "Job Offer Created", message: "Your job offer has been successfully created", preferredStyle: UIAlertController.Style.alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { UIAlertAction in
            self.performSegue(withIdentifier: "reloadJobOffer", sender: nil)
        })
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // Add a new Job Offer
    func addNewOffer(_ companyRfc: String) {
        
        JobOffersDAO.addNewOffer(self.userId, companyRfc, self.titleTextField.text!, self.descriptionTextView.text!, self.vacantsTextField.text!, self.startDateTextField.text!, self.endDateTextField.text!, self.salaryTextField.text!, self.experienceTextField.text!){ (errorHandler) in
                if errorHandler != nil {
                    print(errorHandler!)
                }
                else {
                    self.displayAlert()
                }
        }
    }
    
    // If the 'Create New Offer' button is tapped
    @IBAction func newOfferTapped(_ sender: Any) {
        
        EmployerDAO.getCompamnyRfc(userId) { (companyRfc) in
            self.addNewOffer(companyRfc!)
        }
    }
    
}

// Extension of the class used to define the functionalities of date pickers
extension CreateOfferViewController {
    
    // Put the selected start date in the date picker 1 into the start date textfield
    @objc func startTapDone(){
        if let datePicker = self.startDateTextField.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            self.startDateTextField.text = dateFormatter.string(from: datePicker.date)
        }
        self.startDateTextField.resignFirstResponder()
    }
    
    // Put the selected end date in the date picker 1 into the start date textfield
    @objc func endTapDone(){
        if let datePicker = self.endDateTextField.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            self.endDateTextField.text = dateFormatter.string(from: datePicker.date)
        }
        self.endDateTextField.resignFirstResponder()
    }

}
