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
    @IBOutlet weak var password2TextField: UITextField!
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
    
    func setUpElements() {
        
        // Hide the error label
        errorLabel.alpha = 0
        
        // Style the elements
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleTextField(password2TextField)
        Utilities.styleTextField(companyTextField)
        Utilities.styleTextField(positionTextField)
        Utilities.styleTextField(address1TextField)
        Utilities.styleTextField(address2TextField)
        Utilities.styleTextField(cityTexField)
        Utilities.styleTextField(stateTextField)
        Utilities.styleFilledButton(signUpButton)
    }
    
    // Check the fields nad validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message.
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || password2TextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || companyTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || positionTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || address1TextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || address2TextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || cityTexField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || stateTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all the fields"
        }
        
        // Check if the password is secure
//        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//        
//        if Utilities.isPasswordValid(cleanedPassword) == false {
//            return "Please make sure your password is at least 8 characters, contains a special character and a number"
//        }
        
        return nil
    }
    
    
    // Some error ocurred, show the error message
    func showError(_ message: String){
        
        errorLabel.text = message
        errorLabel.alpha = 1
        
    }
    
    
    // Transition to home function
    func transitionToHome() {
        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeEmployerViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }

    @IBAction func signUpTapped(_ sender: Any) {
        
        // Validate the fields
        let error = validateFields()
        
        if error != nil {
            
            // There's something wrong with the fields, show error message
            showError(error!)
        }
        else {
            // Create the user
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, err) in
                
                // Check for errors
                if err != nil {
                    
                    // There was an error creating the user
                    self.showError("Error creating user")
                }
                else {
                    
                    // User was created successfully, now store the other data
                    let db = Firestore.firestore()
                    
                    db.collection("employers").addDocument(data: [
                        "uid":result!.user.uid,
                        "firstName":self.firstNameTextField.text!,
                        "lastName":self.lastNameTextField.text!,
                        "company":self.companyTextField.text!,
                        "position":self.positionTextField.text!,
                        "address1":self.address1TextField.text!,
                        "address2":self.address2TextField.text!,
                        "city":self.cityTexField.text!,
                        "state":self.stateTextField.text!
                    ]) { (error) in
                        
                        if error != nil {
                            
                            // Show the error message
                            self.showError("Error saving user data")
                        }
                    }
                    
                    // Transition to the home screen
                    self.transitionToHome()
                    
                }
                
            }
            
        }
        
    }
    
    
}
