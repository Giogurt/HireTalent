//
//  SignUpViewController.swift
//  HireTalent
//
//  Created by Ricardo Luna Guerrero on 06/04/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rfcTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var address1TextField: UITextField!
    @IBOutlet weak var address2TextField: UITextField!
    @IBOutlet weak var cityTexField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var positionPicker: UIPickerView!
    
    var pickerData: [String] = [String]()
    var department: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
        
        self.positionPicker.delegate = self
        self.positionPicker.dataSource = self
        pickerData = ["IT", "Merchandising", "Help Desk"]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        department = pickerData[row]
    }
    
    
    // This method is called before the view is actually removed and before any animations are configured.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Shows the navigation bar on other view controllers
        //self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    
    // This function is used to stylize the components of the UI
    func setUpElements() {
        
        // Hide the error label
        errorLabel.alpha = 0
        
        // Style the elements
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleTextField(rfcTextField)
        Utilities.styleTextField(companyTextField)
        Utilities.styleTextField(address1TextField)
        Utilities.styleTextField(address2TextField)
        Utilities.styleTextField(cityTexField)
        Utilities.styleTextField(stateTextField)
        Utilities.styleFilledButton(signUpButton)
    }
    
    
    // Check the fields and validate that the data is correct. If everything is correct, this method returns nil.
    // Otherwise, it returns the error message.
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || rfcTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || companyTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || address1TextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || address2TextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || cityTexField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || stateTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all the fields"
        }
        
        // Check if the password is secure
        if Utilities.isPasswordValid(passwordTextField.text!) == false {
            return "Please make sure your password is at least 8 characters, contains a special character and a number"
        }
        
        return nil
    }
    
    
    // Some error ocurred, show the error message
    func showError(_ message: String){
        
        errorLabel.text = message
        errorLabel.alpha = 1
        
    }
    
    
    // When Sign Up button tapped then...
    @IBAction func signUpTapped(_ sender: Any) {
        
        // Validate the fields
        let error = validateFields()
        
        // Check for errors
        if error != nil {
            
            // There's something wrong with the fields, show error message
            showError(error!)
        }
        else {
            
            // Call the function to create a user
            EmployerDAO.createUser(emailTextField.text!, passwordTextField.text!) { (userRetrieved) in
                
                // If the user was not created correctly
                if userRetrieved == nil {
                    self.showError("There was an error creating the user")
                }
                else {
                    
                    // Call the function to insert the user extra data
                    EmployerDAO.addUserInformation(userRetrieved!, self.firstNameTextField.text!, self.lastNameTextField.text!, self.emailTextField.text!, self.department!, self.rfcTextField.text!) { (userErrorHandler) in
                        
                        // If there was an error storing the user information
                        if userErrorHandler != nil {
                            self.showError(userErrorHandler!)
                        }
                        else {
                            
                            // Call the function to add the company information
                            CompanyDAO.addCompanyInformation(self.rfcTextField.text!, self.companyTextField.text!, self.address1TextField.text!, self.address2TextField.text!, self.cityTexField.text!, self.stateTextField.text!) { (companyErrorHandler) in
                                
                                // If there was an error storing the company information
                                if companyErrorHandler != nil {
                                    self.showError(companyErrorHandler!)
                                }
                                else {
                                    
                                    self.performSegue(withIdentifier: "employerProfileScreen", sender: nil)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
