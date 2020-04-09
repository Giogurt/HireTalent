//
//  SignUpViewController.swift
//  HireTalent
//
//  Created by Ricardo Luna Guerrero on 06/04/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rfcTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var positionTextField: UITextField!
    @IBOutlet weak var address1TextField: UITextField!
    @IBOutlet weak var address2TextField: UITextField!
    @IBOutlet weak var cityTexField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUpElements()
    }
    
    
    // Hide the status bar from the UI
    override var prefersStatusBarHidden: Bool {
        return true
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
        Utilities.styleTextField(positionTextField)
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
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || rfcTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || companyTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || positionTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || address1TextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || address2TextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || cityTexField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || stateTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
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
    
    
    // Transition to home function when Sign Up Button is tapped
    func transitionToHome() {
        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeEmployerViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    
    // Create the user in the Authentication Section of Firebase and register some extra data in the database
    func createUser() {
        
        // Create the user
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, err) in
            
            // Check for errors
            if err != nil {
                
                // There was an error creating the user
                self.showError("Error creating user")
            }
            else {
                
                // Add extra data about the user
                self.addUserInformation(result)
                
            }
        }
    }
    
    
    // Add extra data about the user
    func addUserInformation(_ result: AuthDataResult?) {
        
        let db = Firestore.firestore()
        
        // Use a model to organize the employer information
        var employer = Employer()
        
        employer.firstName = firstNameTextField.text!
        employer.lastName = lastNameTextField.text!
        employer.email = emailTextField.text!
        employer.position = positionTextField.text!
        
        
        // Store the information in the database
        db.collection("employers").document(result!.user.uid).setData([
            "firstName": employer.firstName,
            "lastName": employer.lastName,
            "email": employer.email,
            "position": employer.position
        ]) { (error) in
            
            // Check for errors
            if error != nil {
                
                // There was an error adding the user data to the database
                self.showError("Error saving user data")
            }
        }
        
        // Add data about the company
        addCompanyInformation(result!.user.uid, employer.email)
        
        // Transition to the home screen
        self.transitionToHome()
    }
    
    
    // Add data about the company
    func addCompanyInformation(_ userId: String, _ email: String) {
        
        let db = Firestore.firestore()
        
        // Use a model to organize the company information
        var company = Company()
        
        company.rfc = rfcTextField.text!
        company.name = companyTextField.text!
        company.address_1 = address1TextField.text!
        company.address_2 = address2TextField.text!
        company.city = cityTexField.text!
        company.state = stateTextField.text!
        
        
        // Check if the company data is already registered
        let companyRef = db.collection("company").document(company.rfc)
        
        companyRef.getDocument { (document, error) in
            
            // If document already exists
            if let document = document, document.exists {
                self.makeUserCompanyRelation(userId, email, company.rfc)
            }
            else {
                db.collection("company").document(company.rfc).setData([
                    "name": company.name,
                    "address_1": company.address_1,
                    "address_2": company.address_2,
                    "city": company.city,
                    "state": company.state
                ]) { (error) in
                    
                    // Check for errors
                    if error != nil {
                        
                        // There was an error creating the company
                        self.showError("Error saving company data")
                    }
                }
                
                // Make a relation between the company and the user
                self.makeUserCompanyRelation(userId, email, company.rfc)
            }
        }
    }
    
    
    // Make a relation between the company and the user
    func makeUserCompanyRelation(_ userId: String, _ email: String, _ companyRfc: String) {
        
        let db = Firestore.firestore()
        
        // Check if the company relation is already registered
        let isEmployerRef = db.collection("isEmployer").document(companyRfc)
        
        isEmployerRef.getDocument { (document, error) in
            
            // If document already exists
            if let document = document, document.exists {
                
                // Update the relations of a selected company
                db.collection("isEmployer").document(companyRfc).updateData([
                    userId: email
                ]) { (error) in
                    
                    // Check for errors
                    if error != nil {
                        
                        // There was an error making the relation
                        self.showError("Error making the relation")
                    }
                }
            }
            else {
                
                // Create the relations of a selected company
                db.collection("isEmployer").document(companyRfc).setData([
                    userId: email
                ]) { (error) in
                    
                    // Check for errors
                    if error != nil {
                        
                        // There was an error making the relation
                        self.showError("Error making the relation")
                    }
                }
            }
        }
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
            
            createUser()
            
        }
        
    }
    
}
