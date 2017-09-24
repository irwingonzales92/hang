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
import PMAlertController



enum AnnotationType {
    case user
    case leader
}

enum ButtonAction {
    case startHangout
    case getDirectionsToLeader
    case endHangout
}


class HomeVC: UIViewController, Alertable {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var actionBtn: RoundedShadowButton!
    @IBOutlet var centerMapButton: UIButton!
    @IBOutlet var findFriendsTextfield: UITextField!
    @IBOutlet weak var createMessageBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var roundedShadowView: RoundedShadowView!
    
    
    var actionForButton: ButtonAction = .startHangout
    var manager: CLLocationManager?
    var delegate: CenterVCDelegate?
    var regionRadius: CLLocationDistance = 1000
    let partyCoordinate = CLLocationCoordinate2D()
    var tableView =  UITableView()
    var matchingMapItems: [MKMapItem] = [MKMapItem]()
    var host: user = user()
    var matchingFriend = String()
    let tableViewCell =  UITableViewCell()
    var guestArray = [String]()
    var searchArray = [String]()
    var hangoutTextField = UITextField()
    //var currentUserID = Auth.auth().currentUser?.uid
    var leaderAnnotationImg = UIImage(named: "leaderAnnotationImg")
    var userAnnotationImg = UIImage(named: "currentLocationAnnotation")
    var route: MKRoute!
    
    
    let nib = UINib(nibName: "FriendSearchCell", bundle: Bundle.main)
    let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "launchScreenIcon")!, iconInitialSize: CGSize(width: 80, height: 80), backgroundColor: UIColor.white)
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        if Auth.auth().currentUser == nil {
            loginBtn.setTitle("Login", for: .normal)
            buttonsForUser(areHidden: true)
            print("No user")
        }
        else
        {
            loginBtn.setTitle("Logout", for: .normal)
            loginBtn.titleLabel?.adjustsFontSizeToFitWidth = true
            buttonsForUser(areHidden: false)
        }
        createMessageBtn.isEnabled = false
        mapView.tintColor = UIColor.green //Change color of location bubble
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
                self.setupDelegates()
                self.checkLocationAuthStatus()
                self.centerMapOnUserLocation()
        
                tableView.register(nib, forCellReuseIdentifier: "locationCell")
                
                manager = CLLocationManager()
                manager?.delegate = self
                manager?.desiredAccuracy = kCLLocationAccuracyBest
                

                findFriendsTextfield.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        if Auth.auth().currentUser?.uid != nil
        {
            DataService.instance.checkIfUserIsInHangout(passedUser: (Auth.auth().currentUser)!) { (isInHangout) in
                if isInHangout == true
                {
                    self.actionBtn.setTitle("End Hangout", for: UIControlState.normal)
                    self.loadHangoutAnnotation()
                }
                else
                {
                    self.actionBtn.setTitle("Hangout", for: UIControlState.normal)
                    self.loadUserAnnotationFromFirebase()
                }
            }
        } else
        {
        return
        }

        
        
                self.mapView.addSubview(revealingSplashView)
                revealingSplashView.animationType = SplashAnimationType.heartBeat
                revealingSplashView.startAnimation()
                
                revealingSplashView.heartAttack = true
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(handleScreenTap(sender:)))
                self.view.addGestureRecognizer(tap)
    }
    
    
    
    /// Setup Methods
    func setupDelegates()
    {
        mapView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        findFriendsTextfield.delegate = self
    }
    
    func buttonsForUser(areHidden: Bool) {
        if areHidden == true {
            actionBtn.fadeTo(alphaValue: 0.0, withDuration: 0.2)
            centerMapButton.fadeTo(alphaValue: 0.0, withDuration: 0.2)
            roundedShadowView.fadeTo(alphaValue: 0.0, withDuration: 0.2)
            actionBtn.isHidden = true
            centerMapButton.isHidden = true
            roundedShadowView.isHidden = true
        }
        else
        {
            actionBtn.fadeTo(alphaValue: 1.0, withDuration: 0.2)
            centerMapButton.fadeTo(alphaValue: 1.0, withDuration: 0.2)
            roundedShadowView.fadeTo(alphaValue: 1.0, withDuration: 0.2)
            actionBtn.isHidden = false
            centerMapButton.isHidden = false
            roundedShadowView.isHidden = false
        }
    }
    
    func handleScreenTap(sender: UITapGestureRecognizer)
    {
        self.view.endEditing(true)
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
    
    /// Annotation Loading Functions
    
    // User Annotations
    func loadUserAnnotationFromFirebase()
    {
        DataService.instance.REF_USERS.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let userSnapshot = snapshot.children.allObjects as? [DataSnapshot]
            {
                for user in userSnapshot
                {
                    if user.hasChild(COORDINATE)
                    {
                        //Tell if user is a leader
//                        if driver.childSnapshot(forPath: USER_IS_LEADER).value as? Bool == true {
                        if let userDict = user.value as? Dictionary<String, AnyObject>
                        {
                            let coordnateArray = userDict[COORDINATE] as! NSArray
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
                    //}
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
    
    
    // Hangout Annotations
    func loadHangoutAnnotation()
    {
        DataService.instance.REF_HANGOUT.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let hangSnapshot = snapshot.children.allObjects as? [DataSnapshot]
            {
                for hangout in hangSnapshot
                {
                    if hangout.hasChild("coordinate")
                    {
                        if let hangDict = hangout.value as? Dictionary<String, AnyObject>
                        {
                            let coordnateArray = hangDict["coordinate"] as! NSArray
                            let hangoutCoordinate = CLLocationCoordinate2D(latitude: coordnateArray[0] as! CLLocationDegrees, longitude: coordnateArray[1] as! CLLocationDegrees)
                            
                            let annotation = PartyAnnotation(coordinate: hangoutCoordinate, withKey: hangout.key)
                            
                            var hangoutAreVisible: Bool
                            {
                                return self.mapView.annotations.contains(where: { (annotation) -> Bool in
                                    if let hangoutAnnotation = annotation as? PartyAnnotation
                                    {
                                        if hangoutAnnotation.key == hangout.key
                                        {
                                            hangoutAnnotation.update(annotationPosition: hangoutAnnotation, withCoordinate: hangoutCoordinate)
                                            return true
                                        }
                                    }
                                    return false
                                })
                            }
                            
                            if !hangoutAreVisible
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
                                    if annotation.key == hangout.key
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
    
    /// Helper Methods
    
    func startHangout(hangoutName: String, host: User, coordinate: CLLocationCoordinate2D, guests: Array<Any>)
    {
        let hangoutData = ["provider": host.providerID, "desciption": String(), "hagnoutIsActive": true,"hangoutIsPrivate": Bool(), "owner": host.uid, "startTime": ServerValue.timestamp(), "coordinate": [coordinate.latitude, coordinate.longitude]] as [String : Any]
        
        DataService.instance.createFirebaseDBHangout(uid: host.uid, hangoutData: hangoutData, hangoutName: hangoutName, isHangout: true, guests: guests)
        
        UpdateService.instance.updateUserIsInHangoutStatus(bool: true, passedUser: Auth.auth().currentUser!)
        self.mapView.reloadInputViews()
    }
    
    func endHangout(host:User)
    {
        let hangoutData = ["provider": host.providerID, "desciption": String(), "hagnoutIsActive": false,"hangoutIsPrivate": true, "owner": host.uid, "guests": [], "endTime": ServerValue.timestamp(), "coordinate": []] as [String : Any]
        
        DataService.instance.endFirebaseDBHangout(uid: host.uid, hangoutData: hangoutData)
        
        UpdateService.instance.updateUserIsInHangoutStatus(bool: true, passedUser: Auth.auth().currentUser!)
        self.mapView.reloadInputViews()
    }
    
    
    func centerMapOnUserLocation()
    {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        self.mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    
    /////////////////
    /// IBActions ///
    /////////////////
    
    @IBAction func createBtnPressed(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let createPostVC = storyboard.instantiateViewController(withIdentifier: "CreatePostVC") as? CreatePostVC
        present(createPostVC!, animated: true, completion: nil)
    }
    
    
    @IBAction func actionBtnWasPressed(_ sender: Any)
    {
        
        //buttonSelector(forAction: actionForButton)
        
        
        DataService.instance.checkIfUserIsInHangout(passedUser: (Auth.auth().currentUser)!) { (isInParty) in
            if isInParty == true
            {
                DataService.instance.REF_HANGOUT.observeSingleEvent(of: .value, with: { (snapshot) in
                    if let hangoutSnapshot = snapshot.children.allObjects as? [DataSnapshot]
                    {
                        for hangout in hangoutSnapshot
                        {
                            if hangout.childSnapshot(forPath: "owner").value as? String == Auth.auth().currentUser?.uid
                            {
                                if hangout.childSnapshot(forPath: "hangoutIsActive").value as? Bool == false
                                {
                                    self.actionBtn.animateButton(shouldLoad: true, withMessage: nil)
                                    
                                    let alertVC = PMAlertController(title: "Let's Hangout?", description: "Let's let everyone know what's up", image: UIImage(named: ""), style: .alert)
                                    
                                    
                                    alertVC.addTextField { (textField) in
                                        self.hangoutTextField = textField!
                                        self.hangoutTextField.placeholder = "Name Your Party"
                                    }
                                    
                                    alertVC.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: { () -> Void in
                                        print("Capture action Cancel")
                                    }))
                                    
                                    alertVC.addAction(PMAlertAction(title: "OK", style: .default, action: { () in
                                        print("Capture action OK")
                                        
                                        self.startHangout(hangoutName: "Hangout", host: Auth.auth().currentUser!, coordinate: self.mapView.userLocation.coordinate, guests: self.guestArray)
                                        UpdateService.instance.updateHangoutTitle(title: (self.hangoutTextField.text)!)
                                        UpdateService.instance.updateUserIsInHangoutStatus(bool: true, passedUser: Auth.auth().currentUser!)
                                        print("Party Sucessfully Started")
                                    }))
                                    
                                    self.present(alertVC, animated: true, completion: nil)
                                }
                                else
                                {
                                    print("something is wrong")
                                    let alertVC = PMAlertController(title: "End Hangout?", description: "Ending hangout will close any location services for guests", image: UIImage(named: ""), style: .alert)
                                    
                                    alertVC.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: { () -> Void in
                                        print("Capture action Cancel")
                                    }))
                                    
                                    alertVC.addAction(PMAlertAction(title: "OK", style: .default, action: { () in
                                        print("Capture action OK")
                                        
                                        self.endHangout(host: Auth.auth().currentUser!)
                                        UpdateService.instance.updateUserIsInHangoutStatus(bool: false, passedUser: Auth.auth().currentUser!)
                                        print("Party Sucessfully Ended")
                                    }))
                                    
                                    self.present(alertVC, animated: true, completion: nil)

                                }
                            }
                        }
                    }
                })
            }
            else
            {
                DataService.instance.REF_HANGOUT.observeSingleEvent(of: .value, with: { (snapshot) in
                    if let hangoutSnapshot = snapshot.children.allObjects as? [DataSnapshot]
                    {
                        for hangout in hangoutSnapshot
                        {
                            if hangout.childSnapshot(forPath: "owner").value as? String == Auth.auth().currentUser?.uid
                            {
                                if hangout.childSnapshot(forPath: "hangoutIsActive").value as? Bool == true
                                {
                                    // End Party Functionality
                                    let alertVC = PMAlertController(title: "End Hangout?", description: "Ending hangout will close any location services for guests", image: UIImage(named: ""), style: .alert)
                                    
                                    alertVC.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: { () -> Void in
                                        print("Capture action Cancel")
                                    }))
                                    
                                    alertVC.addAction(PMAlertAction(title: "OK", style: .default, action: { () in
                                        print("Capture action OK")
                                        
                                        self.endHangout(host: Auth.auth().currentUser!)
                                        UpdateService.instance.updateUserIsInHangoutStatus(bool: false, passedUser: Auth.auth().currentUser!)
                                        print("Party Sucessfully Ended")
                                    }))
                                    
                                    self.present(alertVC, animated: true, completion: nil)
                                }
                                else
                                {
                                    print("hangout is not active")
                                    
                                    self.actionBtn.animateButton(shouldLoad: true, withMessage: nil)
                                    
                                    let alertVC = PMAlertController(title: "Let's Hangout?", description: "Let's let everyone know what's up", image: UIImage(named: ""), style: .alert)
                                    
                                    
                                    alertVC.addTextField { (textField) in
                                        self.hangoutTextField = textField!
                                        self.hangoutTextField.placeholder = "Name Your Party"
                                    }
                                    
                                    alertVC.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: { () -> Void in
                                        print("Capture action Cancel")
                                    }))
                                    
                                    alertVC.addAction(PMAlertAction(title: "OK", style: .default, action: { () in
                                        print("Capture action OK")
                                        
                                        self.startHangout(hangoutName: "Hangout", host: Auth.auth().currentUser!, coordinate: self.mapView.userLocation.coordinate, guests: self.guestArray)
                                        UpdateService.instance.updateHangoutTitle(title: (self.hangoutTextField.text)!)
                                        UpdateService.instance.updateUserIsInHangoutStatus(bool: true, passedUser: Auth.auth().currentUser!)
                                        print("Party Sucessfully Started")
                                    }))
                                    
                                    self.present(alertVC, animated: true, completion: nil)
                                }
                            }
                        }
                    }
                })
            }

        }
    }

    @IBAction func centerMapBtnWasPressed(_ sender: Any)
    {
        centerMapOnUserLocation()
        centerMapButton.fadeTo(alphaValue: 0.0, withDuration: 0.2)
    }

    @IBAction func menuBtnWasPressed(_ sender: Any)
    {
        
        
        if Auth.auth().currentUser == nil
        {
            
            delegate?.toggleLoginVC()
        }
        else
        {
            let alertVC = PMAlertController(title: "Would you like to logout?", description: "", image: UIImage(named: ""), style: .alert)
            
            
            alertVC.addAction(PMAlertAction(title: "Cancel", style: .cancel, action:
                { () -> Void in
                print("Capture action Cancel")
            }))
            
            alertVC.addAction(PMAlertAction(title: "Logout", style: .default, action:
                { () -> Void in
                do
                {
                    try Auth.auth().signOut()
                    print("User Successfully Signed Out")
                }
                catch (let error)
                {
                    print(error)
                }
            }))
            self.present(alertVC, animated: true, completion: nil)
            }
        
        
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        let loginVC: UIViewController = (storyBoard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC)!
//        self.present(loginVC, animated: true, completion: nil)
        }
    
    
//    func buttonSelector(forAction action: ButtonAction)
//    {
//        switch action {
//            case .startHangout
//                UpdateService.instance.updateTripsWithCoordinatesUponRequest()
//                actionBtn.animateButton(shouldLoad: true, withMessage: nil)
//        
//            case .getDirectionsToLeader
//            
//        
//            case .endHangout
//            
//        }
//    }
    
    
    
    
    
    }

/// Extensions


////////////////
/// MAP VIEW ///
////////////////


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
        UpdateService.instance.updateUserLocation(withCoordinate: userLocation.coordinate)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if let annotation = annotation as? PartyAnnotation
        {
            let identifier = "party"
            
            var view: MKAnnotationView
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.image = userAnnotationImg
            
            return view
            
        } else if let annotation = annotation as? LeaderAnnotation {
            let identifier = "leader"
            var view: MKAnnotationView
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            view.tintColor = UIColor.red
            view.image = leaderAnnotationImg
            return view
        }
        
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool)
    {
        centerMapButton.fadeTo(alphaValue: 1.0, withDuration: 0.2)
    }
    
    //How the route overlay should show up
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let lineRenderer = MKPolylineRenderer(overlay: (self.route?.polyline)!)
        lineRenderer.strokeColor = UIColor(red: 186/255, green: 11/255, blue: 224/255, alpha: 0.8)
        lineRenderer.lineWidth = 3
        
        ShouldPresentLoadingView(false)
        
        return lineRenderer
    }
    
    
    //capture the current location of the user and search mapkit for a route using the destination location.
    func searchMapKitForResultsWithPolyline(forOriginMapItem originMapItem: MKMapItem, withDestinationMapItem destinationMapItem: MKMapItem)
    {
        let request = MKDirectionsRequest()
        
        if originMapItem == nil {
            request.source = MKMapItem.forCurrentLocation()
        } else {
            request.source = originMapItem
        }
        
        request.destination = destinationMapItem
        request.transportType = MKDirectionsTransportType.automobile
        request.requestsAlternateRoutes = true
//        request.transportType = MKDirectionsTransportType.transit
//        request.transportType = MKDirectionsTransportType.walking
        
        let directions = MKDirections(request: request)
        
        directions.calculate { (response, error) in
            guard let response = response else {
                self.showAlert("An error occurred, please try again.")
                return
            }
            self.route = response.routes[0]
            self.mapView.add(self.route.polyline) //display the route as a solid line on the map
        }
    }
    
    //Show passenger and destination annotation on map
    func zoom(toFitAnnotationsFromMapView mapView: MKMapView, forActiveTripToLeader: Bool, withKey key: String?) {
        if mapView.annotations.count == 0 {
            return
        }
        
        var topLeftCoordinate = CLLocationCoordinate2D(latitude: -90, longitude: 180)
        var bottomRightCoordinate = CLLocationCoordinate2D(latitude: 90, longitude: -180)
        
        if forActiveTripToLeader {
            for annotation in mapView.annotations {
                if let annotation = annotation as? PartyAnnotation {
                    if annotation.key == key {
                        topLeftCoordinate.longitude = fmin(topLeftCoordinate.longitude, annotation.coordinate.longitude)
                        topLeftCoordinate.latitude = fmax(topLeftCoordinate.latitude, annotation.coordinate.latitude)
                        bottomRightCoordinate.longitude = fmax(bottomRightCoordinate.longitude, annotation.coordinate.longitude)
                        bottomRightCoordinate.latitude = fmin(bottomRightCoordinate.latitude, annotation.coordinate.latitude)
                    }
                } else {
                    topLeftCoordinate.longitude = fmin(topLeftCoordinate.longitude, annotation.coordinate.longitude)
                    topLeftCoordinate.latitude = fmax(topLeftCoordinate.latitude, annotation.coordinate.latitude)
                    bottomRightCoordinate.longitude = fmax(bottomRightCoordinate.longitude, annotation.coordinate.longitude)
                    bottomRightCoordinate.latitude = fmin(bottomRightCoordinate.latitude, annotation.coordinate.latitude)
                }
            }
        }
        
        
        for annotation in mapView.annotations where !annotation.isKind(of: PartyAnnotation.self) {
            topLeftCoordinate.longitude = fmin(topLeftCoordinate.longitude, annotation.coordinate.longitude)
            topLeftCoordinate.latitude = fmax(topLeftCoordinate.latitude, annotation.coordinate.latitude)
            bottomRightCoordinate.longitude = fmax(bottomRightCoordinate.longitude, annotation.coordinate.longitude)
            bottomRightCoordinate.latitude = fmin(bottomRightCoordinate.latitude, annotation.coordinate.latitude)
        }
        
        var region = MKCoordinateRegion (center: CLLocationCoordinate2DMake(topLeftCoordinate.latitude - (topLeftCoordinate.latitude - bottomRightCoordinate.latitude) * 0.5, topLeftCoordinate.longitude + (bottomRightCoordinate.longitude - topLeftCoordinate.longitude) * 0.5), span: MKCoordinateSpan(latitudeDelta: fabs(topLeftCoordinate.latitude - bottomRightCoordinate.latitude) * 2.0, longitudeDelta: fabs(bottomRightCoordinate.longitude - topLeftCoordinate.longitude) * 2.0))
        
        region = mapView.regionThatFits(region)
        mapView.setRegion(region, animated: true)
    }
    
    
    
    
}








/////////////////
/// TEXTFIELD ///
/////////////////

extension HomeVC: UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == self.findFriendsTextfield
        {
            
            tableView.frame = CGRect(x: 20, y: view.frame.height, width: view.frame.width - 40, height: view.frame.height - 170)
            tableView.layer.cornerRadius = 5.0

            
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
    
    @objc func textFieldDidChange()
    {
        if findFriendsTextfield.text == " "
        {
            guestArray = []
            self.tableView.reloadData()
        }
        else
        {
            DataService.instance.getUser(forSearchQuery: findFriendsTextfield.text!, handler: { (friendArray) in
                debugPrint(friendArray)
                self.guestArray = friendArray
                self.tableView.reloadData()
                print("Successfully reloaded")
            })
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == findFriendsTextfield
        {
            DataService.instance.getUser(forSearchQuery: self.findFriendsTextfield.text!, handler: { (friendArray) in
                self.searchArray = friendArray
            })
            
            view.endEditing(true)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        tableView.removeFromSuperview()
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! FriendSearchCell
        
        cell.usernameLabel.text = guestArray[indexPath.row]
        
        
//        DataService.instance.getUser(forSearchQuery: self.findFriendsTextfield.text!) { (friendArray) in
//            cell.textLabel?.text = friendArray[indexPath.row]
//        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return guestArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        let leaderCoordinate = manager?.location?.coordinate
        let leaderAnnotation = LeaderAnnotation(coordinate: leaderCoordinate!, withKey: (Auth.auth().currentUser?.uid)!)
        mapView.addAnnotation(leaderAnnotation)
        
        
        
        let alertVC = PMAlertController(title: "Add Firend?", description: "Your friend will be able to see your location in real time", image: UIImage(named: ""), style: .alert)
        
        alertVC.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: { () -> Void in
            print("Capture action Cancel")
        }))
        
        alertVC.addAction(PMAlertAction(title: "OK", style: .default, action: { () in
            UpdateService.instance.addUsersIntoGuestList(users: self.guestArray)

            print("Capture action OK")
            print("Friend is added!")
            
            self.guestArray.insert(self.matchingFriend, at: indexPath.row)
            self.dismiss(animated: true, completion: nil)
        }))
        
        //DataService.instance.REF_USERS.child((Auth.auth().currentUser?.uid)!).updateChildValues([TRIP_COORDINATE: [selectedMapItem.placemark.coordinate.latitude, selectedMapItem.placemark.coordinate.longitude]])
        
        
        self.present(alertVC, animated: true, completion: nil)

        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        view.endEditing(true)
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    {
        if self.findFriendsTextfield.text == ""
        {
            animateTableView(shouldShow: false)
        }
    }
}



