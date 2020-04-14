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
            print("email \(email) password \(password)")
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
    
    
    static func addStudent(id: String, student: Student, completion: @escaping((_ data: String?) -> Void)){
       
        let db = Firestore.firestore()
        
        db.collection("students").document("\(id)").setData([
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
    // Get the user id
       static func getStudentId() -> String {
           return Auth.auth().currentUser!.uid
       }
       
    
    static func getStudent(_ userId: String, completion: @escaping(((String?), (Student?)) -> Void)) {
    
        // Establish the connection with the database
        let db = Firestore.firestore()
        
        // Set a reference to the desired document
        let ref = db.collection("students").document(userId)
        
        ref.getDocument { (document, error) in
            
            // If the specified document exist
            if let document = document, document.exists {
                
                let empData = document.data()
                var student = Student()
                
                student.firstName = empData!["firstName"] as? String ?? ""
                student.lastName = empData!["lastName"] as? String ?? ""
                student.email = empData!["email"] as? String ?? ""
                student.city = empData!["city"] as? String ?? "Lol"
                student.state = empData!["state"] as? String ?? "Lol"
                student.school = empData!["school"] as? String ?? "Lol"
                student.major = empData!["major"] as? String ?? "Lol"
                student.semester = empData!["semester"] as? String ?? "Lol"
                student.experience = empData!["experience"] as? String ?? "Lol"
                // Returns an object employer with all their data
                completion(nil, student)
            } else {
                
                // Returns an error message
                completion("Error retrieving the user data getStudent", nil)
                print("Error retrieving the user data getStudent")
            }
        }
    }
}
