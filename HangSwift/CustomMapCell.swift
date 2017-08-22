//
//  CustomMapCell.swift
//  HangSwift
//
//  Created by Irwin Gonzales on 8/18/17.
//  Copyright © 2017 Irwin Gonzales. All rights reserved.
//

import UIKit
import MapKit

class CustomMapCell: UITableViewCell {
    
    @IBOutlet var mapView: MKMapView!
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.mapView.delegate = self as! MKMapViewDelegate
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension CustomImageCell: MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation)
    {
        UpdateService.instance.updateUserLocationWithCoordinate(coordinate: userLocation.coordinate)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if let annotation = annotation as? PartyAnnotation
        {
            let identifier = "party"
            
            var view: MKAnnotationView
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.image = UIImage(named: "driverAnnotation")
            
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool)
    {
        //        centerMapButton.fadeTo(alphaValue: 1.0, withDuration: 0.2)
    }
        
}
