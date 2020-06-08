//
//  RatingControl.swift
//  HireTalent
//
//  Created by user168029 on 5/26/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
    
    //MARK: Properties
    private var ratingButtons = [UIButton]()
    
    var rating = 0
    var employer = Employer()

    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    //MARK: Private Methods
    
    private func setupButtons() {
        
        for _ in 0..<5 {
            let button = UIButton()
            button.backgroundColor = UIColor.red
            
            //Add constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
            button.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
            
            // Setup the button action
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            // Add the button to the stack
            addArrangedSubview(button)
            
            //Add the new button to the rating button array
            ratingButtons.append(button)
        }
    }
    
    //MARK: Button Action
    
    @objc func ratingButtonTapped(button: UIButton) {
    print("Button pressed 👍")
}
}
