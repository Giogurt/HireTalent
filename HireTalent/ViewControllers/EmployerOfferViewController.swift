//
//  EmployerOfferViewController.swift
//  HireTalent
//
//  Created by user168029 on 4/28/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import UIKit

class EmployerOfferViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var studentsButton: UIButton!
    
    var offer: JobOffer = JobOffer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = self.offer.jobTitle
    }

    
}
