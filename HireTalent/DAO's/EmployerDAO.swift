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
    // It is used a callback because we depend of the 'result' provided by the createUser() function,
    // so in any of both cases we return a String to the ViewController indicating the result of the
    // operation.
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
    // It is used a callback because we depend of the 'result' provided by the createUser() function,
    // so in any of both cases we return a String to the ViewController indicating the result of the
    // operation.
    static func addUserInformation(_ userId: String, _ firstName: String, _ lastName: String, _ email: String, _ position: String, completion: @escaping((_ data: String?) -> Void)){
        
        // Establish the connection with the database
        let db = Firestore.firestore()
        
        // Use a model to organize the employer information
        var employer = Employer()

        employer.firstName = firstName
        employer.lastName = lastName
        employer.email = email
        employer.position = position


        // Store the information in the database
        db.collection("employers").document(userId).setData([
            "firstName": employer.firstName,
            "lastName": employer.lastName,
            "email": employer.email,
            "position": employer.position
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

}
