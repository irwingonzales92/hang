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


class HomeVC: UIViewController {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var actionBtn: RoundedShadowButton!
    @IBOutlet var centerMapButton: UIButton!
    @IBOutlet var findFriendsTextfield: UITextField!
    @IBOutlet weak var createMessageBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    
    
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
    var route: MKRoute!
    
    
    let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "launchScreenIcon")!, iconInitialSize: CGSize(width: 80, height: 80), backgroundColor: UIColor.white)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if Auth.auth().currentUser == nil {
            
            print("No user")
            loginBtn.setTitle("Login", for: .normal)
            let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
            present(loginVC!, animated: true, completion: nil)
        } else {
            
            
            
            do {
                print("User")
                loginBtn.setTitle("Logout", for: .normal)
                loginBtn.titleLabel?.adjustsFontSizeToFitWidth = true 
                
                mapView.backgroundColor = UIColor.purple
                mapView.tintColor = UIColor.green //Change color of location bubble
                
                createMessageBtn.isEnabled = false
                
                //tableView.register(FriendSearchCell.self, forCellReuseIdentifier: "locationCell")
                let nib = UINib(nibName: "FriendSearchCell", bundle: Bundle.main)
                tableView.register(nib, forCellReuseIdentifier: "locationCell")
                
                manager = CLLocationManager()
                manager?.delegate = self
                manager?.desiredAccuracy = kCLLocationAccuracyBest
                
                self.setupDelegates()
                
                findFriendsTextfield.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
                
                
                self.checkLocationAuthStatus()
                self.centerMapOnUserLocation()
                
                DataService.instance.checkIfUserIsInHangout(passedUser: Auth.auth().currentUser!) { (isInHangout) in
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
                
                self.mapView.addSubview(revealingSplashView)
                revealingSplashView.animationType = SplashAnimationType.heartBeat
                revealingSplashView.startAnimation()
                
                revealingSplashView.heartAttack = true
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(handleScreenTap(sender:)))
                self.view.addGestureRecognizer(tap)
                
            } catch (let error) {
                print(error)
            }
        }
        
    }
    
    /// Setup Methods
    func setupDelegates()
    {
        mapView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        findFriendsTextfield.delegate = self
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
    
    /// Actions
    @IBAction func createBtnPressed(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let createPostVC = storyboard.instantiateViewController(withIdentifier: "CreatePostVC") as? CreatePostVC
        present(createPostVC!, animated: true, completion: nil)
    }
    
    
    @IBAction func actionBtnWasPressed(_ sender: Any)
    {
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
        //delegate?.toggleLeftPanel()
        
        if Auth.auth().currentUser == nil {
            
            let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
            present(loginVC!, animated: true, completion: nil)
        } else {
            do {
                

                let alertVC = PMAlertController(title: "Would you like to logout?", description: "", image: UIImage(named: ""), style: .alert)
                
                
                alertVC.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: { () -> Void in
                    print("Capture action Cancel")
                }))
                
                alertVC.addAction(PMAlertAction(title: "Logout", style: .default, action: { () in
                    print("Capture action LOGOUT")
                
                    try Auth.auth().signOut()
                } as! (() -> Void)))
                
                self.present(alertVC, animated: true, completion: nil)

            } catch (let error) {
                print(error)
            }
        }

        
    }
}

/// Extensions

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
        } else if let annotation = annotation as? LeaderAnnotation {
            let identifier = "leader"
            var view: MKAnnotationView
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.image = leaderAnnotationImg
            
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool)
    {
        centerMapButton.fadeTo(alphaValue: 1.0, withDuration: 0.2)
    }
    
    
    
    //capture the current location of the user and search mapkit for a route using the destination location.
    func searchMapKitForResultsWithPolyline(forMapItem mapItem: MKMapItem) {
        let request = MKDirectionsRequest()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = mapItem
        request.transportType = MKDirectionsTransportType.automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            guard let response = response else {
                print(error.debugDescription)
                return
            }
            self.route = response.routes[0] //pull the first route in the array because it tends to be the quickest
            
            self.mapView.add(self.route.polyline) //display the route as a solid line on the map
        }
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



