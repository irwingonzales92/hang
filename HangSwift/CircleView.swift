//
//  CircleView.swift
//  Hitchhiker-Dev
//
//  Created by Irwin Gonzales on 7/8/17.
//  Copyright © 2017 Irwin Gonzales. All rights reserved.
//

import UIKit

class CircleView: UIView
{
    @IBInspectable var borderColor: UIColor?
    {
        didSet
        {
            setupView()
        }
    }
    
    override func awakeFromNib()
    {
        setupView()
    }
    
    func setupView()
    {
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.borderWidth = 1.5
        self.layer.borderColor = borderColor?.cgColor
    }

}
