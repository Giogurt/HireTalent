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
    static func addNewOffer(_ userId: String, _ companyRfc: String, _ jobTitle: String, _ jobDescription: String, _ vacants: String, _ startDate: String, _ endDate: String, _ salary: String, _ experience: String, completion: @escaping((_ data: String?) -> Void)){
        
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
        
        // Set the document data
        db.collection("offers").document().setData([
            "userId": userId,
            "companyRfc": companyRfc,
            "jobTitle": jobOffer.jobTitle,
            "jobDescription": jobOffer.jobDescription,
            "vacants": jobOffer.vacants,
            "startDate": jobOffer.startDate,
            "endDate": jobOffer.endDate,
            "salary": jobOffer.salary,
            "experience": jobOffer.experience,
            "interestedStudents": jobOffer.interestedStudents
        ]) { (error) in
            
            // Check for erros
            if error != nil {
                
                // There was an error adding the offer to the database
                completion("Error")
            }
            
            completion(nil)
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
                    offer.endDate = offerData["endDate"] as? String ?? ""
                    offer.experience = offerData["experience"] as? Int ?? 0
                    offer.jobDescription = offerData["jobDescription"] as? String ?? ""
                    offer.jobTitle = offerData["jobTitle"] as? String ?? ""
                    offer.salary = offerData["salary"] as? Int ?? 0
                    offer.startDate = offerData["jobDescription"] as? String ?? ""
                    offer.vacants = offerData["vacants"] as? Int ?? 0
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
                    jobOffer.jobTitle = document.data()["jobTitle"] as? String ?? ""
                    jobOffer.jobDescription = document.data()["jobDescription"] as? String ?? ""
                    jobOffer.vacants = document.data()["vacants"] as? Int ?? 0
                    jobOffer.startDate = document.data()["startDate"] as? String ?? ""
                    jobOffer.endDate = document.data()["endDate"] as? String ?? ""
                    jobOffer.salary = document.data()["salary"] as? Int ?? 0
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
