//
//  EmployerDAO.swift
//  HireTalent
//
//  Created by Ricardo Luna Guerrero on 08/04/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase

class EmployerDAO {
    
    // Create the user adding it to the Authentication Section of Firebase.
    // It is used a callback because we depend of the 'result' provided by the createUser() function.
    static func createUser(_ email:String, _ password: String, completion: @escaping((_ data: String?) -> Void)) {
        
        // Create the user
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            
            // Check for errors
            if err != nil {
                
                // There was an error creating the user
                completion(nil)
            }
            else {
                
                // Add extra data about the user
                completion(result!.user.uid)
            }
        }
    }
    
    
    // Insert extra data about the user in the database.
    // It is used a callback because we depend of the 'result' provided by the setData() function.
    static func addEmployerInformation(_ userId: String, _ firstName: String, _ lastName: String, _ email: String, _ position: String, _ company_rfc: String, completion: @escaping((_ data: String?) -> Void)){
        
        // Establish the connection with the database
        let db = Firestore.firestore()
        
        // Use a model to organize the employer information
        var employer = Employer()

        employer.firstName = firstName
        employer.lastName = lastName
        employer.email = email
        employer.position = position
        employer.company_rfc = company_rfc


        // Store the information in the database
        db.collection("employers").document(userId).setData([
            "firstName": employer.firstName,
            "lastName": employer.lastName,
            "email": employer.email,
            "position": employer.position,
            "company_rfc": employer.company_rfc
        ]) { (error) in

            // Check for errors
            if error != nil {

                // There was an error adding the user data to the database
                completion("Error creating the user")
            }
            
            // If the insertion was executed correctly return nil
            completion(nil)
        }
    }
    
    
    // Get the user id
    static func getUserId() -> String {
        return Auth.auth().currentUser!.uid
    }
    
    
    // Get the company rfc
    static func getCompamnyRfc(_ userId: String, completion: @escaping((_ data: String?) -> Void)) {
        
        // Establish the connection with the database
        let db = Firestore.firestore()
        
        // Set a reference to the desired document
        let empRef = db.collection("employers").document(userId)
        
        empRef.getDocument { (document, error) in
            
            // If the specified document exist
            if let document = document, document.exists {
                
                let empData = document.data()
                var companyRfc: String
                
                companyRfc = empData!["company_rfc"] as? String ?? ""
                
                // Returns an object company with all its data
                completion(companyRfc)
            } else {
                
                // Returns an error message
                completion("Error retrieving the user data")
            }
        }
    }
    
    
    // Get the general information of the employer
    static func getEmployerInformation(_ userId: String, completion: @escaping(((String?), (Employer?)) -> Void)) {
    
        // Establish the connection with the database
        let db = Firestore.firestore()
        
        // Set a reference to the desired document
        let empRef = db.collection("employers").document(userId)
        
        empRef.getDocument { (document, error) in
            
            // If the specified document exist
            if let document = document, document.exists {
                
                let empData = document.data()
                var employer = Employer()
                
                employer.firstName = empData!["firstName"] as? String ?? ""
                employer.lastName = empData!["lastName"] as? String ?? ""
                employer.email = empData!["email"] as? String ?? ""
                employer.position = empData!["position"] as? String ?? ""
                employer.company_rfc = empData!["company_rfc"] as? String ?? ""
                
                // Returns an object employer with all their data
                completion(nil, employer)
            } else {
                
                // Returns an error message
                completion("Error retrieving the user data", nil)
            }
        }
    }
}
