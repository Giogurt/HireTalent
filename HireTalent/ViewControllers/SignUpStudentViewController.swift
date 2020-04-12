//
//  SignUpStudentViewController.swift
//  HireTalent
//
//  Created by Andres Ruiz Navejas on 12/04/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import UIKit

class SignUpStudentViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var schoolTextField: UITextField!
    @IBOutlet weak var majorTextField: UITextField!
    @IBOutlet weak var semesterTextField: UITextField!
    
    @IBOutlet weak var chooseProfilePictureButton: UIButton!
    
    var lastName: String?
    var firstName: String?
    var email: String?
    var password:String?
    var confirmPassword:String?
    var city: String?
    var state: String?
    var school: String?
    var major: String?
    var semester: String?
    
    var profilePicture: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lastNameTextField.delegate = self
        firstNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        cityTextField.delegate = self
        stateTextField.delegate = self
        schoolTextField.delegate = self
        majorTextField.delegate = self
        semesterTextField.delegate = self

        errorLabel.isHidden = true
    }
    
    @IBAction func chooseProfilePicture(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .photoLibrary
        
        imagePickerController.delegate = self
        
        present(imagePickerController,animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let currentProfilePicture = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else{
            fatalError("did not get the image, instead got \(info)")
        }
        
        profilePicture = currentProfilePicture
        dismiss(animated: true, completion: nil)
        chooseProfilePictureButton.setTitle("Change profile picture", for: .normal)
    }
    
    @IBAction func next(_ sender: UIBarButtonItem) {
        getValues()
        if(lastName == "" || firstName == "" || email == "" || password == "" || confirmPassword == "" || city == "" || state == "" || school == "" || major == "" || semester == ""){
            errorLabel.isHidden = false
            errorLabel.text = "Fill in all the fields"
            return
        }
        if(passwordTextField.text != confirmPasswordTextField.text){
            errorLabel.isHidden = false

            errorLabel.text = "passwords don't match"
            return
        }
        if(profilePicture == nil){
            errorLabel.isHidden = false

            errorLabel.text = "missing profile picture"
            return
        }
        //prepare for segue and perform segue to experienceViewController
        performSegue(withIdentifier: "experienceIdentifier", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "experienceIdentifier" {
            let destinationExperience = segue.destination as! ExperienceViewController
            destinationExperience.lastName = lastName
            destinationExperience.firstName = firstName
            destinationExperience.email = email
            destinationExperience.password = password
            destinationExperience.confirmPassword = confirmPassword
            destinationExperience.city = city
            destinationExperience.state = state
            destinationExperience.school = school
            destinationExperience.major = major
            destinationExperience.semester = semester
            destinationExperience.profilePicture = profilePicture
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    func getValues() {
        lastName = lastNameTextField.text ?? ""
        firstName = firstNameTextField.text ?? ""
        email = emailTextField.text ?? ""
        password = passwordTextField.text ?? ""
        confirmPassword = confirmPasswordTextField.text ?? ""
        city = cityTextField.text ?? ""
        state = stateTextField.text ?? ""
        school = schoolTextField.text ?? ""
        major = majorTextField.text  ?? ""
        semester = semesterTextField.text ?? ""
    }
}
