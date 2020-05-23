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
    
    // Create the user adding it to the Authentication Section of Firebase.
    // It is used a callback because we depend of the 'result' provided by the createUser() function.
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
    
    
    // Insert the student data in the database.
    // It is used a callback because we depend of the 'result' provided by the setData() function.
    static func addStudent(id: String, student: Student, completion: @escaping((_ data: String?) -> Void)){
       
        // Establish the connection with the database
        let db = Firestore.firestore()
        
            // Store the information in the database
        db.collection("students").document("\(id)").setData([
            "firstName": student.firstName,
            "lastName": student.lastName,
            "email": student.email,
            "city": student.city,
            "state": student.state,
            "school": student.school,
            "major": student.major,
            "semester": student.semester,
            "experience": student.experience,
            "notifications": student.notifications
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
    
    
    static func editStudent(id: String, student: Student, completion: @escaping((_ data: String?) -> Void)){
       
        // Establish the connection with the database
        let db = Firestore.firestore()
        
        // Store the information in the database
        db.collection("students").document("\(id)").updateData([
            "firstName": student.firstName,
            "lastName": student.lastName,
            "city": student.city,
            "state": student.state,
            "school": student.school,
            "major": student.major,
            "semester": student.semester,
            "experience": student.experience,
            "notifications": student.notifications
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
    
    // Delete student account
    static func deleteStudent(id: String) {
        
        // Establish the connection with the database
        let db = Firestore.firestore()
        
        // Delete the student information in the database
        db.collection("students").document("\(id)").delete()
        
        // Delete the information from authentication
        Auth.auth().currentUser?.delete()
    }
    
    // Get the user id
    static func getStudentId() -> String {
        return Auth.auth().currentUser!.uid
    }
    
    // Get the major of the student
    static func getStudentMajor(_ studentId: String, completion: @escaping(String?) -> Void){
        
        // Establish the connection with the database
        let db = Firestore.firestore()
        
        let docRef = db.collection("students").document(studentId)
        
        docRef.getDocument(){ (document, error) in
            
            // If the specified document exists
            if let document = document, document.exists {
                
                let studentData = document.data()
                
                let major = studentData!["major"] as? String ?? ""
                
                completion(major)
            }
        }
    }
       
    
    // Get the general information of the student
    static func getStudent(_ userId: String, completion: @escaping(((String?), (Student?)) -> Void)) {
    
        // Establish the connection with the database
        let db = Firestore.firestore()
        
        // Set a reference to the desired document
        let ref = db.collection("students").document(userId)
        
        ref.getDocument { (document, error) in
            
            // If the specified document exists
            if let document = document, document.exists {
                
                let empData = document.data()
                var student = Student()
                
                student.firstName = empData!["firstName"] as? String ?? ""
                student.lastName = empData!["lastName"] as? String ?? ""
                student.email = empData!["email"] as? String ?? ""
                student.city = empData!["city"] as? String ?? ""
                student.state = empData!["state"] as? String ?? ""
                student.school = empData!["school"] as? String ?? ""
                student.major = empData!["major"] as? String ?? ""
                student.semester = empData!["semester"] as? String ?? ""
                student.experience = empData!["experience"] as? String ?? ""
                student.notifications = empData!["notifications"] as? [String] ?? []
                // Returns an object employer with all their data
                completion(nil, student)
            } else {
                
                // Returns an error message
                completion("Error retrieving the user data getStudent", nil)
            }
        }
    }
    
    
    // Get a set of students given their student ids
    static func getStudents(_ studentIds: [String], completion: @escaping(([Student]?, [String]?) -> Void)) {
    
        // Establish the connection with the database
        let db = Firestore.firestore()
        
        // Variables used to store the students' information
        var students: [Student] = []
        var newStudentsIds: [String] = []
        var c = 0
        
        // For each student
        for studentId in studentIds {
            
            // Set a reference to the desired document
            let ref = db.collection("students").document(studentId)
            
            ref.getDocument { (document, error) in
                
                // If the specified document exists
                if let document = document, document.exists {
                    
                    let studentData = document.data()
                    var student = Student()
                    
                    student.firstName = studentData!["firstName"] as? String ?? ""
                    student.lastName = studentData!["lastName"] as? String ?? ""
                    student.email = studentData!["email"] as? String ?? ""
                    student.city = studentData!["city"] as? String ?? ""
                    student.state = studentData!["state"] as? String ?? ""
                    student.school = studentData!["school"] as? String ?? ""
                    student.major = studentData!["major"] as? String ?? ""
                    student.semester = studentData!["semester"] as? String ?? ""
                    student.experience = studentData!["experience"] as? String ?? ""
                    student.notifications = studentData!["notifications"] as? [String] ?? []
                    
                    c += 1
                    students.append(student)
                    
                    // For some strange reason the documents are not opened in the same order
                    // that the original studentIds array. For this reason, it is used a new
                    // array to keep the same order in the students and in their ids
                    newStudentsIds.append(document.documentID)
                    
                }
                
                if c == studentIds.count {
                    completion(students, newStudentsIds)
                }
                
            }
        }
    }
    
    
    // Get a set of filtered students given their student ids and a speciality field
    static func getFilteredStudents(_ studentIds: [String], _ specialityField: String, completion: @escaping(([Student]?, [String]?) -> Void)) {
    
        // Establish the connection with the database
        let db = Firestore.firestore()
        
        // Variables used to store the students' information
        var students: [Student] = []
        var newStudentsIds: [String] = []
        var numberOfStudents = 0
        
        // For each student
        for studentId in studentIds {
            
            // Set a reference to the desired document
            let ref = db.collection("students").document(studentId)
            
            ref.getDocument { (document, error) in
                
                // If the specified document exists
                if let document = document, document.exists {
                    
                    let studentData = document.data()
                    let studentMajor = studentData!["major"] as? String ?? ""
                    
                    // If the student's major is the adequate, then gather all the student data
                    if studentMajor == specialityField {
                        var student = Student()
                        
                        student.firstName = studentData!["firstName"] as? String ?? ""
                        student.lastName = studentData!["lastName"] as? String ?? ""
                        student.email = studentData!["email"] as? String ?? ""
                        student.city = studentData!["city"] as? String ?? ""
                        student.state = studentData!["state"] as? String ?? ""
                        student.school = studentData!["school"] as? String ?? ""
                        student.major = studentMajor
                        student.semester = studentData!["semester"] as? String ?? ""
                        student.experience = studentData!["experience"] as? String ?? ""
                        student.notifications = studentData!["notifications"] as? [String] ?? []
                        
                        students.append(student)
                        
                        // For some strange reason the documents are not opened in the same order
                        // that the original studentIds array. For this reason, it is used a new
                        // array to keep the same order in the students and in their ids
                        newStudentsIds.append(document.documentID)
                    }
                }
                
                numberOfStudents += 1
                
                if numberOfStudents == studentIds.count {
                    print(students)
                    completion(students, newStudentsIds)
                }
            }
        }
    }
}
