//
//  HomeVC.swift
//  Hitchhiker-Dev
//
//  Created by Irwin Gonzales on 7/5/17.
//  Copyright © 2017 Irwin Gonzales. All rights reserved.
//

import UIKit
import MapKit
import RevealingSplashView
import CoreLocation
import Firebase
import PopupDialog


class HomeVC: UIViewController {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var actionBtn: RoundedShadowButton!
    @IBOutlet var centerMapButton: UIButton!
    @IBOutlet var findFriendsTextfield: UITextField!
    
    var manager: CLLocationManager?
    var delegate: CenterVCDelegate?
    var regionRadius: CLLocationDistance = 1000
    let partyCoordinate = CLLocationCoordinate2D()
    var tableView =  UITableView()
    var matchingMapItems: [MKMapItem] = [MKMapItem]()
    var host: user = user()
    var matchingFriend = String()
    let tableViewCell =  UITableViewCell()
    var guestArray = Array<Any>()
    
    
    let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "launchScreenIcon")!, iconInitialSize: CGSize(width: 80, height: 80), backgroundColor: UIColor.white)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        manager = CLLocationManager()
        manager?.delegate = self
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        
        
        self.checkLocationAuthStatus()
        self.centerMapOnUserLocation()
        
        DataService.instance.REF_USERS.observe(.value, with: { (snapshot) in
            self.loadUserAnnotationFromFirebase()
        })
        
        self.setupDelegates()
        self.mapView.addSubview(revealingSplashView)
        revealingSplashView.animationType = SplashAnimationType.heartBeat
        revealingSplashView.startAnimation()
        
        revealingSplashView.heartAttack = true
        
    }
    
    func setupDelegates()
    {
        mapView.delegate = self
        findFriendsTextfield.delegate = self
    }
    
    func checkLocationAuthStatus()
    {
        if CLLocationManager.authorizationStatus() == .authorizedAlways
        {
            
            manager?.startUpdatingLocation()
        }
        else
        {
            manager?.requestAlwaysAuthorization()
        }
    }
    
    func loadUserAnnotationFromFirebase()
    {
        DataService.instance.REF_USERS.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let userSnapshot = snapshot.children.allObjects as? [DataSnapshot]
            {
                for user in userSnapshot
                {
                    if user.hasChild("coordinate")
                    {
                        if let userDict = user.value as? Dictionary<String, AnyObject>
                        {
                            let coordnateArray = userDict["coordinate"] as! NSArray
                            let userCoordinate = CLLocationCoordinate2D(latitude: coordnateArray[0] as! CLLocationDegrees, longitude: coordnateArray[1] as! CLLocationDegrees)
                            
                            let annotation = PartyAnnotation(coordinate: userCoordinate, withKey: user.key)
                            
                            var usersAreVisible: Bool
                            {
                                return self.mapView.annotations.contains(where: { (annotation) -> Bool in
                                    if let userAnnotation = annotation as? PartyAnnotation
                                    {
                                        if userAnnotation.key == user.key
                                        {
                                            userAnnotation.update(annotationPosition: userAnnotation, withCoordinate: userCoordinate)
                                            return true
                                        }
                                     }
                                    return false
                                })
                            }
                            if !usersAreVisible
                            {
                                self.mapView.addAnnotation(annotation)
                            }
                        }
                    }
                    else
                    {
                        for annotation in self.mapView.annotations
                        {
                            if annotation.isKind(of: PartyAnnotation.self)
                            {
                                if let annotation = annotation as? PartyAnnotation
                                {
                                    if annotation.key == user.key
                                    {
                                        self.mapView.removeAnnotation(annotation)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        })
    }
    
    
    //    LOCATION SEARCH FUNCTION
    //
    //    func perfomSearch()
    //    {
    //        matchingMapItems.removeAll()
    //
    //        let request = MKLocalSearchRequest()
    //        request.naturalLanguageQuery = locationSearchTextField
    //    }
    
    func startHangout(hangoutName: String, host: User, coordinate: CLLocationCoordinate2D, guests: Array<Any>)
    {
        DataService.instance.REF_HANGOUT.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.children.allObjects is [DataSnapshot]
            {
                if host.uid == Auth.auth().currentUser?.uid
                {
                    let hangoutData = [ "hangoutName": hangoutName, "provider": host.providerID, "desciption": String(), "hagnoutIsActive": Bool(),"hangoutIsPrivate": Bool(), "startTime": ServerValue.timestamp(), "coordinate": [coordinate.latitude, coordinate.longitude]] as [String : Any]
                    
                    DataService.instance.createFirebaseDBHangout(uid: host.uid, hangoutData: hangoutData, hangoutName: hangoutName, isHangout: true, guests: guests)
                    
                    UpdateService.instance.updateUserIsInHangoutStatus(bool: true)
                }
            }
        })
    }
    
    func searchForFriendsWithUsername(username: String) -> String
    {
        DataService.instance.REF_USERS.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.children.allObjects is [DataSnapshot]
            {
                DataService.instance.REF_USERS.queryOrdered(byChild: "username").queryEqual(toValue: username)
            }
        })
        return username
    }
    
    
    func centerMapOnUserLocation()
    {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        self.mapView.setRegion(coordinateRegion, animated: true)
    }

    @IBAction func actionBtnWasPressed(_ sender: Any)
    {
        actionBtn.animateButton(shouldLoad: true, withMessage: nil)
        
        // Prepare the popup assets
        let title = "Start A Party?"
        let message = "The party is about to start, are the details correct?"
        let image = UIImage(named: "")
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: image)
        
        // Create buttons
        let buttonOne = DefaultButton(title: "Start Party", height: 60)
        {
            self.startHangout(hangoutName: "Hangout", host: Auth.auth().currentUser!, coordinate: self.mapView.userLocation.coordinate, guests: self.guestArray)
            print("Party Sucessfully Started")
        }

        let buttonTwo = DefaultButton(title: "Edit Details")
        {
            print("What a beauty!")
        }
        
        let buttonThree = CancelButton(title: "Nevermind")
        {
            print("You canceled the car dialog.")
        }
        
        
        // Add buttons to dialog
        // Alternatively, you can use popup.addButton(buttonOne)
        // to add a single button
        popup.addButtons([buttonOne, buttonTwo, buttonThree])
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
    }

    @IBAction func centerMapBtnWasPressed(_ sender: Any)
    {
        centerMapOnUserLocation()
        centerMapButton.fadeTo(alphaValue: 0.0, withDuration: 0.2)
    }

    @IBAction func menuBtnWasPressed(_ sender: Any)
    {
        delegate?.toggleLeftPanel()
    }
}


extension HomeVC: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        if status == .authorizedAlways
        {
            checkLocationAuthStatus()
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .follow
        }
    }
}

extension HomeVC: MKMapViewDelegate
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
        centerMapButton.fadeTo(alphaValue: 1.0, withDuration: 0.2)
    }
    
}

extension HomeVC: UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == self.findFriendsTextfield
        {
            
            tableView.frame = CGRect(x: 20, y: view.frame.height, width: view.frame.width - 40, height: view.frame.height - 170)
            tableView.layer.cornerRadius = 5.0
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "locationCell")
            
            tableView.delegate = self as UITableViewDelegate
            tableView.dataSource = self as UITableViewDataSource
            
            tableView.tag = 7
            tableView.rowHeight = 60
            
            view.addSubview(tableView)
            animateTableView(shouldShow: true)
        }
        else
        {
            print("Problem came up")
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == findFriendsTextfield
        {
            // perform search function
            view.endEditing(true)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool
    {
        centerMapOnUserLocation()
        return true
    }
    
    func animateTableView(shouldShow: Bool)
    {
        if shouldShow
        {
            UIView.animate(withDuration: 0.2, animations:
                {
                self.tableView.frame = CGRect(x: 20, y: 170, width: self.view.frame.width - 40, height: self.view.frame.height - 170)
                    
            })
        }
        else
        {
            UIView.animate(withDuration: 0.2, animations: {
                self.tableView.frame = CGRect(x: 20, y: self.view.frame.height, width: self.view.frame.width - 40, height: self.view.frame.height - 170)
            }, completion: { (finished) in
                for subview in self.view.subviews
                {
                    if subview.tag == 7
                    {
                        subview.removeFromSuperview()
                    }
                }
            })
        }
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        matchingFriend = searchForFriendsWithUsername(username: self.findFriendsTextfield.text!)
        self.tableViewCell.textLabel?.text = matchingFriend
        
        return self.tableViewCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        animateTableView(shouldShow: false)
        print("selelcted")
        
        // Add Alert View that allows users to invite friends to hang out.
        
    }
}



