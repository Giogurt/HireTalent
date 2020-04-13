//
//  StudentDAO.swift
//  HireTalent
//
//  Created by Andres Ruiz Navejas on 12/04/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class StudentDAO{
    static func createStudentCredentials(_ email:String, _ password: String, completion: @escaping((_ data: String?) -> Void)) {
        
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
    
    static func addStudent(student: Student, completion: @escaping((_ data: String?) -> Void)){
       
        let db = Firestore.firestore()
        
        db.collection("students").document("id").setData([
            "firstName": student.firstName,
            "lastName": student.lastName,
            "email": student.email,
            "password": student.password,
            "city": student.city,
            "state": student.state,
            "school": student.school,
            "major": student.major,
            "semester": student.semester,
            "experience": student.experience,
            "profilePicture": "picture not implemented"
        ])
        { (error) in

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
