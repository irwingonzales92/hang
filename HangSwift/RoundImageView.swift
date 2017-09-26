//
//  RoundImageView.swift
//  
//
//  Created by Irwin Gonzales on 7/8/17.
//  Copyright © 2017 Irwin Gonzales. All rights reserved.
//

import UIKit

class RoundImageView: UIImageView {
    
    override func awakeFromNib()
    {
        setupView()
    }

    func setupView()
    {
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
    
}
