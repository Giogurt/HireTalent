//
//  StudentHomeViewController.swift
//  HireTalent
//
//  Created by Andres Ruiz Navejas on 12/04/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import UIKit

class StudentHomeViewController: UIViewController {

    @IBOutlet weak var experienceLabel: UITextView!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var semesterLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var navBar: UINavigationItem!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initProfile()
        // Do any additional setup after loading the view.
    }
    
    func initProfile(){
          
        let userId = StudentDAO.getStudentId()
          
        StudentDAO.getStudent(userId) { (error, student) in
              
            if error != nil {
                print(error!)
            }
            else {
                self.fullName.text = student!.self.firstName + " " + student!.self.lastName
                self.emailLabel.text = student!.self.email
                self.locationLabel.text = student!.self.city + ", " + student!.self.state
                self.schoolLabel.text = student!.self.school
                self.majorLabel.text = student!.self.major
                self.semesterLabel.text = student!.self.semester
                self.experienceLabel.text = student!.self.experience
            }
        }
    }
}
