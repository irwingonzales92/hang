//
//  LeaderAnnotation.swift
//  HangSwift
//
//  Created by Kenton D. Raiford on 9/14/17.
//  Copyright © 2017 Kenton D. Raiford. All rights reserved.
//

import Foundation
import MapKit

class LeaderAnnotation: NSObject, MKAnnotation {
    dynamic var coordinate: CLLocationCoordinate2D
    var key: String
    
    init(coordinate: CLLocationCoordinate2D, withKey key: String)
    {
        self.coordinate = coordinate
        self.key = key
        
        super.init()
    }
    
    func update(annotationPosition annotation: LeaderAnnotation, withCoordinate coordinate: CLLocationCoordinate2D)
    {
        var location = self.coordinate
        location.latitude = coordinate.latitude
        location.longitude = coordinate.longitude
        
        UIView.animate(withDuration: 0.2)
        {
            self.coordinate = location
        }
    }
}
