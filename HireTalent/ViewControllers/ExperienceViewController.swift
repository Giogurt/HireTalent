//
//  ExperienceViewController.swift
//  HireTalent
//
//  Created by Andres Ruiz Navejas on 12/04/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import UIKit

class ExperienceViewController: UIViewController, UITextViewDelegate{
    var lastName: String?
    var firstName: String?
    var email: String?
    var password:String?
    var confirmPassword:String?
    var city: String?
    var state: String?
    var school: String?
    var major: String?
    var semester: String?
    
    var profilePicture: UIImage?
    var experience: String?
    
    var startedEditing = false
    @IBOutlet weak var experienceTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        experienceTextView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        experience = experienceTextView.text
    }
    @IBAction func signUp(_ sender: UIBarButtonItem) {
    }
    
}
