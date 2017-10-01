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
        
        
//        locationPlacemark = MKPlacemark(coordinate: userCoordinate)
//        centerMapOnLocation(location: locationPlacemark.location!)
        
        DataService.instance.REF_HANGOUT.child(leaderKey).observe(.value, with: { (hangoutSnapshot) in
            if hangoutSnapshot.exists() {
                //check for acceptance
                if hangoutSnapshot.childSnapshot(forPath: "hangoutIsAccepted").value as? Bool == true {
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
    
    
    @IBAction func acceptHangoutBtnWasPressed(_ sender: Any) {
        UpdateService.instance.acceptHangout(withLeaderKey: leaderKey, forGuestKey: (Auth.auth().currentUser?.uid)!)
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
