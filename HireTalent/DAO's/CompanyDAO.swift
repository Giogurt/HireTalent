//
//  CompanyDAO.swift
//  HireTalent
//
//  Created by Ricardo Luna Guerrero on 09/04/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import Foundation
import Firebase

class CompanyDAO {
    
    // Add the company data.
    // It is used a callback because we depend of the 'result' provided by the setData() function,
    // so in any of both cases we return a String to the ViewController indicating the result of the
    // operation.
    static func addCompanyInformation(_ rfc: String, _ name: String, _ address_1: String, _ address_2: String, _ city: String, _ state: String, completion: @escaping((_ data: String?) -> Void)) {
        
        // Establish the connection with the database
        let db = Firestore.firestore()
        
        // Use a model to organize the company information
        var company = Company()
        
        company.rfc = rfc
        company.name = name
        company.address_1 = address_1
        company.address_2 = address_2
        company.city = city
        company.state = state
        
        // Check if the company data is already registered
        let companyRef = db.collection("company").document(company.rfc)

        companyRef.getDocument { (document, error) in

            // If document already exists
            if let document = document, document.exists {
                completion(nil)
            }
            else {
                db.collection("company").document(company.rfc).setData([
                    "name": company.name,
                    "address_1": company.address_1,
                    "address_2": company.address_2,
                    "city": company.city,
                    "state": company.state
                ]) { (error) in

                   // Check for errors
                    if error != nil {

                        // There was an error creating the company
                        completion("There was an error creating the company")
                    }
                }
                completion(nil)
            }
        }
    }


    // Make a relation between the company and the user.
    // It is used a callback because we depend of the 'result' provided by the setData() and updateData()
    // functions, so in any of both cases we return a String to the ViewController indicating the result of
    // the operation.
    static func makeUserCompanyRelation(_ rfc: String, _ userId: String, _ email: String, completion: @escaping((_ data: String?) -> Void)) {
        
        // Establish the connection with the database
        let db = Firestore.firestore()
        
        
        // Check if the company relation is already registered
        let isEmployerRef = db.collection("isEmployer").document(rfc)

        isEmployerRef.getDocument { (document, error) in

            // If document already exists
            if let document = document, document.exists {

                // Update the relations of a selected company
                db.collection("isEmployer").document(rfc).updateData([
                    userId: email
                ]) { (error) in

                    // Check for errors
                    if error != nil {

                        // There was an error making the relation
                        completion("There was not possible to link the specified user and company")
                    }
                }
            }
            else {

                // Create the relations of a selected company
                db.collection("isEmployer").document(rfc).setData([
                    userId: email
                ]) { (error) in

                    // Check for errors
                    if error != nil {

                        // There was an error making the relation
                        completion("There was not possible to link the specified user and company")
                    }
                }
            }
            completion(nil)
        }
    }
}
