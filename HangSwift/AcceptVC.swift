//
//  AcceptVC.swift
//  HangSwift
//
//  Created by Kenton D. Raiford on 9/25/17.
//  Copyright © 2017 Kenton D. Raiford. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class AcceptVC: UIViewController {

    @IBOutlet weak var acceptMapView: RoundMapView!
    
    var userCoordinate: CLLocationCoordinate2D!
    var leaderKey: String!
    
    var regionRadius: CLLocationDistance = 2000 //meters
    var pin: MKPlacemark? = nil
    
    var locationPlacemark: MKPlacemark!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        acceptMapView.delegate = self
        
        locationPlacemark = MKPlacemark(coordinate: userCoordinate)
        centerMapOnLocation(location: locationPlacemark.location!)
        
        DataService.instance.REF_TRIPS.child(leaderKey).observe(.value, with: { (tripSnapshot) in
            if tripSnapshot.exists() {
                //check for acceptance
                if tripSnapshot.childSnapshot(forPath: "hangoutIsAccepted").value as? Bool == true {
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    func initData(coordinate: CLLocationCoordinate2D, leaderKey: String) {
        self.userCoordinate = coordinate
        self.leaderKey = leaderKey
    }
    
    
    @IBAction func acceptTripBtnWasPressed(_ sender: Any) {
        UpdateService.instance.acceptTrip(withLeaderKey: leaderKey, forUserKey: (Auth.auth().currentUser?.uid)!)
        presentingViewController?.ShouldPresentLoadingView(true)
    }
    
    @IBAction func cancelBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}


extension AcceptVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "leaderPoint"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.image = UIImage(named: "destinationAnnotation")
        
        return annotationView
    }
    
    func centerMapOnLocation(location: CLLocation) {
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        acceptMapView.setRegion(coordinateRegion, animated: true)
        
    }
    
    
}
