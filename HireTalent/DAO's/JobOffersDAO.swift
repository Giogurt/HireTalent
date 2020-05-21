//
//  JobOffersDAO.swift
//  HireTalent
//
//  Created by Ricardo Luna Guerrero on 17/04/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import Foundation
import Firebase

class JobOffersDAO {
    
    // Insert a new job offer in the database.
    // It is used a callback because we depend of the 'result' provided by the setData() function.
    static func addNewOffer(_ userId: String, _ companyRfc: String, _ jobTitle: String, _ jobDescription: String, _ vacants: String, _ startDate: String, _ endDate: String, _ salary: String, _ experience: String, _ companyName: String, _ specialityField: String, completion: @escaping((_ data: String?) -> Void)){
        
        // Establish the connection with the database
        let db = Firestore.firestore()
        
        // Use a model to organize the employer information
        var jobOffer = JobOffer()
        
        jobOffer.jobTitle = jobTitle
        jobOffer.jobDescription = jobDescription
        jobOffer.vacants = Int(vacants)!
        jobOffer.startDate  = startDate
        jobOffer.endDate = endDate
        jobOffer.salary = Int(salary)!
        jobOffer.experience = Int(experience)!
        jobOffer.specialityField = specialityField
        let collection = db.collection("offers")
        let newDoc = collection.document()
        let key = newDoc.documentID
        let dataKey = ["offerKey": key]
        
        // Set the document data
        db.collection("offers").document(key).setData([
            "userId": userId,
            "companyRfc": companyRfc,
            "companyName": companyName,
            "jobTitle": jobOffer.jobTitle,
            "jobDescription": jobOffer.jobDescription,
            "vacants": jobOffer.vacants,
            "startDate": jobOffer.startDate,
            "endDate": jobOffer.endDate,
            "salary": jobOffer.salary,
            "experience": jobOffer.experience,
            "specialityField": jobOffer.specialityField,
            "interestedStudents": jobOffer.interestedStudents,
            "open": true
        ]) { (error) in
            
            // Check for erros
            if error != nil {
                
                // There was an error adding the offer to the database
                completion("Error")
            }
            newDoc.setData(dataKey, merge: true)
            completion(nil)
        }
    }
    
    static func editOffer( jobOffer:JobOffer, completion: @escaping((_ data: String?) -> Void)){
       
        // Establish the connection with the database
        let db = Firestore.firestore()
        
            // Store the information in the database
        
        db.collection("offers").document(jobOffer.offerKey).updateData([
              "jobTitle": jobOffer.jobTitle,
                      "jobDescription": jobOffer.jobDescription,
                      "vacants": jobOffer.vacants,
                      "startDate": jobOffer.startDate,
                      "endDate": jobOffer.endDate,
                      "salary": jobOffer.salary,
                      "experience": jobOffer.experience,
            
        ]) { (error) in

            // Check for errors
            if error != nil {

                // There was an error adding the user data to the database
                completion("Error editing the offer")
            }

            // If the insertion was executed correctly return nil
            completion(nil)
        }
    }
    
    
    static func editOpen(jobOffer: JobOffer, completion: @escaping((_ data: String?) -> Void)){
    
     // Establish the connection with the database
     let db = Firestore.firestore()
     
         // Store the information in the database
     
     db.collection("offers").document(jobOffer.offerKey).updateData([
           "open": jobOffer.open
         
     ]) { (error) in

         // Check for errors
         if error != nil {

             // There was an error adding the user data to the database
             completion("Error editing the offer opennes in dao")
         }

         // If the insertion was executed correctly return nil
         completion(nil)
     }
    }
    
    
    static func deleteOffer(offer: JobOffer){
        let db = Firestore.firestore()
        
        db.collection("offers").document(offer.offerKey).delete { (error) in
            //Some code
            if error != nil{
                print("error deleting offer: " + offer.offerKey)
            }
            
        }
    }
    // Retrieve the offers of an employer from the database.
    // It is used a callback because we depend of the 'result' provided by the setData() function.
    static func getOffers(_ userId: String, completion: @escaping(((String?), ([JobOffer]?)) -> Void)){
        
        // Establish the connection with the database
        let db = Firestore.firestore()
        
        // Queries for the documents owned by the current employer
        let offersRef = db.collection("offers").whereField("userId", isEqualTo: userId)

        offersRef.getDocuments { (snapshot, error ) in
            
            //There is an error
            if error == nil && snapshot != nil {
                
                // Use a model to organize the offer information
                var jobOffers: [JobOffer] = []
                
                for document in snapshot!.documents {
                    let offerData = document.data()
                    var offer = JobOffer()
                
                    offer.jobOfferId = document.documentID
                    offer.offerKey = offerData["offerKey"] as? String ?? ""
                    offer.companyName = offerData["companyName"] as? String ?? ""
                    offer.endDate = offerData["endDate"] as? String ?? ""
                    offer.experience = offerData["experience"] as? Int ?? 0
                    offer.jobDescription = offerData["jobDescription"] as? String ?? ""
                    offer.jobTitle = offerData["jobTitle"] as? String ?? ""
                    offer.salary = offerData["salary"] as? Int ?? 0
                    offer.startDate = offerData["startDate"] as? String ?? ""
                    offer.vacants = offerData["vacants"] as? Int ?? 0
                    offer.open = offerData["open"] as? Bool ?? false
                    offer.interestedStudents = offerData["interestedStudents"] as? [String] ?? []
                    
                    jobOffers.append(offer)
                }
                
                completion(nil, jobOffers)
            } else {
                completion("Failed to retrieve offers from employer", nil)
            }
        }
    }
    
    
    // Get all the Job Offers
    static func getAllJobOffers(completion: @escaping(([JobOffer]?)->Void)){
        
        // Establish the connection with the database
        let db = Firestore.firestore()
        
        // Set a reference to the desired collection
        db.collection("offers").getDocuments() { (querySnapshot, err) in
            
            if let err = err {
                
                print("Error getting the documents: \(err)")
                completion(nil)
                
            } else {
                
                var jobOffers: [JobOffer] = []
                var jobOffer = JobOffer()
                for document in querySnapshot!.documents {
                    
                    jobOffer.jobOfferId = document.documentID
                    jobOffer.offerKey = document.data()["offerKey"] as? String ?? ""
                    jobOffer.jobTitle = document.data()["jobTitle"] as? String ?? ""
                    jobOffer.jobDescription = document.data()["jobDescription"] as? String ?? ""
                    jobOffer.vacants = document.data()["vacants"] as? Int ?? 0
                    jobOffer.startDate = document.data()["startDate"] as? String ?? ""
                    jobOffer.endDate = document.data()["endDate"] as? String ?? ""
                    jobOffer.companyName = document.data()["companyName"] as? String ?? ""
                    jobOffer.salary = document.data()["salary"] as? Int ?? 0
                    jobOffer.open = document.data()["open"] as? Bool ?? false
                    jobOffer.experience = document.data()["experience"] as? Int ?? 0
                    jobOffer.interestedStudents = document.data()["interestedStudents"] as? [String] ?? []
                    jobOffers.append(jobOffer)
                }
                
                completion(jobOffers)
            }
        }
    }
    
    // Add a interested student in a job offer
    static func addANewInterestedStudentToAJobOffer(_ documentId: String, _ interestedStudents: [String], completion: @escaping(String?) -> Void){
        
        // Establish the connection with the database
        let db = Firestore.firestore()
        
        // Set a reference to the desired document
        let ref = db.collection("offers").document(documentId)
        
        ref.updateData([
            "interestedStudents": interestedStudents
        ]) { err in
            if err != nil{
                completion("There was some error adding the student")
            } else {
                completion(nil)
            }
        }
    }
   
}
