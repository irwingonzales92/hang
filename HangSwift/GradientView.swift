//
//  GradientView.swift
//  
//
//  Created by Irwin Gonzales on 7/7/17.
//  Copyright © 2017 Irwin Gonzales. All rights reserved.
//

import UIKit

class GradientView: UIView {

    let gradient = CAGradientLayer()
    
    override func awakeFromNib()
    {
        setupGradientView()
    }
    
    func setupGradientView()
    {
        gradient.frame = self.bounds
        gradient.colors = [UIColor.white.cgColor, UIColor.init(white: 1.0, alpha: 0.0).cgColor]
        gradient.startPoint = CGPoint.zero
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.locations = [0.8, 1.0]
        self.layer.addSublayer(gradient)
    }

}
