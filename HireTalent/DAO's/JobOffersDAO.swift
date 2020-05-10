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
                    
                    offer.endDate = offerData["endDate"] as? String ?? ""
                    offer.experience = offerData["experience"] as? Int ?? 0
                    offer.jobDescription = offerData["jobDescription"] as? String ?? ""
                    offer.jobTitle = offerData["jobTitle"] as? String ?? ""
                    offer.salary = offerData["salary"] as? Int ?? 0
                    offer.startDate = offerData["startDate"] as? String ?? ""
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
    
   
}
