//
//  CustomMapCell.swift
//  HangSwift
//
//  Created by Irwin Gonzales on 8/18/17.
//  Copyright © 2017 Irwin Gonzales. All rights reserved.
//

import UIKit
import MapKit

class CustomMapCell: UITableViewCell, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        
        mapView.delegate = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
