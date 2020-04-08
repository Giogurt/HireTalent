//
//  Employer.swift
//  HireTalent
//
//  Created by Ricardo Luna Guerrero on 08/04/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import Foundation

class Employer {
    
    let firstName: String?
    let lastName: String?
    let email: String?
    
    init(_ fName: String, _ lName: String, _ mail: String){
        firstName = fName
        lastName = lName
        email = mail
    }
}
