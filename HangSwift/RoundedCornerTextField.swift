//
//  RoundedCornerTextField.swift
//  
//
//  Created by Irwin Gonzales on 7/14/17.
//  Copyright © 2017 Irwin Gonzales. All rights reserved.
//

import UIKit

class RoundedCornerTextField: UITextField {

    override func awakeFromNib() {
        setupView()
    }
    
    func setupView()
    {
        self.layer.cornerRadius = self.frame.height / 2
    }

}
