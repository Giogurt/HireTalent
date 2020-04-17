//
//  HomeViewController.swift
//  HireTalent
//
//  Created by Ricardo Luna Guerrero on 06/04/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class HomeViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var positionTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var address1TextField: UITextField!
    @IBOutlet weak var address2TextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var profilePhotoContainer: UIView!
    @IBOutlet weak var profilePhoto: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Stylize the UI elements
        setupElements()
        
        // Get and display the user information
        initProfile()
    }
    
    
    // Stylize the UI elements
    func setupElements(){
        
        // Stylize the TextFields
        Utilities.styleDisplayTextField(emailTextField)
        Utilities.styleDisplayTextField(positionTextField)
        Utilities.styleDisplayTextField(companyTextField)
        Utilities.styleDisplayTextField(address1TextField)
        Utilities.styleDisplayTextField(address2TextField)
        Utilities.styleDisplayTextField(cityTextField)
        Utilities.styleDisplayTextField(stateTextField)
        
        // Make the TextFields not editable
        emailTextField.isUserInteractionEnabled = false
        positionTextField.isUserInteractionEnabled = false
        companyTextField.isUserInteractionEnabled = false
        address1TextField.isUserInteractionEnabled = false
        address2TextField.isUserInteractionEnabled = false
        cityTextField.isUserInteractionEnabled = false
        stateTextField.isUserInteractionEnabled = false
        
        // Make the profile photo container round
        profilePhotoContainer?.layer.cornerRadius = (profilePhotoContainer?.frame.size.width ?? 0.0)/2
    }
    
    
    // Get and display the user information
    func initProfile(){
        
        // Catch the userId of the user logged in
        let userId = EmployerDAO.getUserId()
        
        // Get the employer information
        EmployerDAO.getEmployerInformation(userId) { (error, employer) in
            
            if error != nil {
                
            }
            else {
                self.nameLabel.text = employer!.self.firstName.uppercased() + " " + employer!.self.lastName.uppercased()
                self.emailTextField.text = employer!.self.email
                self.positionTextField.text = employer!.self.position

                let companyRfc = employer!.self.company_rfc

                // Get the company information of a selected user
                CompanyDAO.getCompanyInformation(companyRfc) { (error, company) in

                    if error != nil {

                    }
                    else {
                        self.companyTextField.text = company!.self.name
                        self.address1TextField.text = company!.self.address_1
                        self.address2TextField.text = company!.self.address_2
                        self.cityTextField.text = company!.self.city
                        self.stateTextField.text = company!.self.state
                    }
                }
            }
        }
    }
}
