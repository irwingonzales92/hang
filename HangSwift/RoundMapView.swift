//
//  RoundMapView.swift
//  HangSwift
//
//  Created by Kenton D. Raiford on 9/25/17.
//  Copyright © 2017 Kenton D. Raiford. All rights reserved.
//

import UIKit
import MapKit

class RoundMapView: MKMapView {
    
    override func awakeFromNib() {
        setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 10.0
    }
    
}
