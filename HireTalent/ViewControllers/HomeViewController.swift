//
//  HomeViewController.swift
//  HireTalent
//
//  Created by Ricardo Luna Guerrero on 06/04/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class HomeViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var address1Label: UILabel!
    @IBOutlet weak var address2Label: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initProfile()
    }
    
    
    func initProfile(){
        
        let userId = EmployerDAO.getUserId()
        
        EmployerDAO.getEmployerInformation(userId) { (error, employer) in
            
            if error != nil {
                
            }
            else {
                self.nameLabel.text = employer!.self.firstName + " " + employer!.self.lastName
                self.emailLabel.text = employer!.self.email
                self.positionLabel.text = employer!.self.position
                
                let companyRfc = employer!.self.company_rfc
                
                CompanyDAO.getCompanyInformation(companyRfc) { (error, company) in
                    
                    if error != nil {
                        
                    }
                    else {
                        self.companyLabel.text = company!.self.name
                        self.address1Label.text = company!.self.address_1
                        self.address2Label.text = company!.self.address_2
                        self.cityLabel.text = company!.self.city
                        self.stateLabel.text = company!.self.state
                    }
                }
            }
        }
        
    }
    
    


}
