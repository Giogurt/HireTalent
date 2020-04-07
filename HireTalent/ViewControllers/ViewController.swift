//
//  ViewController.swift
//  HireTalent
//
//  Created by Ricardo Luna Guerrero on 05/04/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import UIKit
import AVKit
import FirebaseDatabase

class ViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpElements()
    }
    
    func setUpElements() {
        
        // Style the elements
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(loginButton)
    }


}

