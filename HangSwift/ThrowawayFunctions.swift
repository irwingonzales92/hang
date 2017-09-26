//
//  ThrowawayFunctions.swift
//  HangSwift
//
//  Created by Irwin Gonzales on 8/22/17.
//  Copyright © 2017 Irwin Gonzales. All rights reserved.
//

import Foundation

//    Observer Function - DataService
//
//    func observeUsers()
//    {
//        DataService.instance.REF_USERS.observeSingleEvent(of: .value, with: { (snapshot) in
//            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]
//            {
//                for snap in snapshot
//                {
//                    if snap.key == Auth.auth().currentUser?.uid
//                    {
//                        self.userAcctTyleLbl.text = "USER"
//
//                    }
//                }
//            }
//        })
//
//        DataService.instance.REF_HANGOUT.observeSingleEvent(of: .value, with: { (snapshot) in
//            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]
//            {
//                for snap in snapshot
//                {
//                    if snap.key == Auth.auth().currentUser?.uid
//                    {
//                       self.userAcctTyleLbl.text = "PARTY"
//
//                    }
//                }
//            }
//        })
//    }

//    LOCATION SEARCH FUNCTION - HomeVC
//
//    func perfomSearch()
//    {
//        matchingMapItems.removeAll()
//
//        let request = MKLocalSearchRequest()
//        request.naturalLanguageQuery = locationSearchTextField
//    }

//    USER DISPLAY NAME CHANGE
/*
 if let user = Auth.auth().currentUser {
 let changeRequest = user.createProfileChangeRequest()
 changeRequest.displayName = "My name"
 changeRequest.commitChanges(completion: nil)
 }
 */

//            {
//                Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
//                    if error == nil
//                    {
//                        // Check if user exists
//                        if let user = user
//                        {
////                            let userData = ["provider": user.providerID, "userIsInParty": false, "userEmail": user.email!, "username": username] as [String: Any]
////                            DataService.instance.createFirebaseDBUsers(uid: user.uid, userData: userData, username: username, isParty: false)
//
////                            let userData = ["provider": user.providerID, "userIsParty": true, "isSessionModeEnabled": false, "partyIsInSession": false] as [String: Any]
////                            DataService.instance.createFirebaseDBUsers(uid: user.uid, userData: userData, username: username, isParty: true)
//
//                        }
//                        print("Email user authenticated successfully with Firebase")
//                        self.dismiss(animated: true, completion: nil)
//                    }
//                    else
//                    {
//                        if let errorCode = AuthErrorCode(rawValue: error!._code)
//                        {
//                            switch errorCode
//                            {
//                            case .emailAlreadyInUse:
//                                print("That email is already in use, please try again")
//
//                            case .wrongPassword:
//                                print("Oops, wrong password")
//
//                            case .credentialAlreadyInUse:
//                                print("Username Already Taken")
//
//                            default:
//                                print(error as Any)
//                            }
//                        }
//
//                        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
//                            if error != nil
//                            {
//                                // Error handels
//                                if let errorCode = AuthErrorCode(rawValue: error!._code)
//                                {
//                                    switch errorCode
//                                    {
//                                    case .emailAlreadyInUse:
//                                        print("That email is already in use, please try again")
//
//                                    case .invalidEmail:
//                                        print("That is an invalid email, please try again")
//
//                                    default:
//                                        //print("Oops, something wrong happened")
//                                        print(error as Any)
//
//                                    }
//                                }
//                            }
//                            else
//                            {
//                                if let user = user
//                                {
//
////                                    let userData = ["provider": user.providerID, "userIsInParty": false, "userEmail": self.emailTextField.text!, "username": username] as [String: Any]
////                                    DataService.instance.createFirebaseDBUsers(uid: user.uid, userData: userData, username: username, isParty: false)
//
////                                        let userData = ["provider": user.providerID, "userIsParty": true, "isSessionModeEnabled": false, "partyIsOnSession": false] as [String: Any]
////                                        DataService.instance.createFirebaseDBUsers(uid: user.uid, userData: userData, username: username, isParty: true)
//
//                                }
//
//                                print("Successfully created a new user with Firebase")
//                                self.dismiss(animated: true, completion: nil)
//                            }
//                        })
//                    }
//
//                })
//            }

//            if let email = emailTextField.text, let password = passwordTextField.text, let username = self.usernameTextField.text
//            {
//                AuthService.instance.registerUser(withEmail: email, Password: password, andUsername: username, userCreationComplete: { (user, error) in
//                    if error == nil
//                    {
//                        print("Email user authenticated successfully with Firebase")
//                        self.dismiss(animated: true, completion: nil)
//                    }
//                    else
//                    {
//                        if let errorCode = AuthErrorCode(rawValue: error!._code)
//                        {
//                            switch errorCode
//                            {
//                            case .emailAlreadyInUse:
//                                self.showAlert("Email is in use")
//
//                            case .wrongPassword:
//                                self.showAlert("Wrong Password")
//                            case .credentialAlreadyInUse:
//                                self.showAlert("Username already taken")
//
//                            default:
//                                self.showAlert(error as Any as! String)
//                                print(error as Any)
//                            }
//                        }
//                    }
//                })
//            }

/* Was inside of App Delegate attempting to present LoginVC if user has no account and HomeVC if user does have an account.
 
 if Auth.auth().currentUser?.uid == nil 
 {
 
 let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
 let initialViewController: UIViewController = (storyBoard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC)!
 self.window?.rootViewController = initialViewController
 self.window?.makeKeyAndVisible()
 
 } 
 else
 {
 
 let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
 let initialViewController: UIViewController = (storyBoard.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC)!
 self.window?.rootViewController = initialViewController
 self.window?.makeKeyAndVisible()
 
 }
 
 
 
 
 
 
 
 
 
 ///////////////////////////
 ///// FORMER ACTION BTN/////
 ///////////////////////////
 
 //buttonSelector(forAction: actionForButton)
 
 //        UpdateService.instance.updateTripsWithCoordinatesUponRequest()
 //        self.view.endEditing(true)
 
 
 //        DataService.instance.checkIfUserIsInHangout(passedUser: (Auth.auth().currentUser)!) { (isInParty) in
 //            if isInParty == true
 //            {
 //                DataService.instance.REF_HANGOUT.observeSingleEvent(of: .value, with: { (snapshot) in
 //                    if let hangoutSnapshot = snapshot.children.allObjects as? [DataSnapshot]
 //                    {
 //                        for hangout in hangoutSnapshot
 //                        {
 //                            if hangout.childSnapshot(forPath: "owner").value as? String == Auth.auth().currentUser?.uid
 //                            {
 //                                if hangout.childSnapshot(forPath: "hangoutIsActive").value as? Bool == false
 //                                {
 //                                    self.actionBtn.animateButton(shouldLoad: true, withMessage: nil)
 //
 //                                    let alertVC = PMAlertController(title: "Let's Hangout?", description: "Let's let everyone know what's up", image: UIImage(named: ""), style: .alert)
 //
 //
 //                                    alertVC.addTextField { (textField) in
 //                                        self.hangoutTextField = textField!
 //                                        self.hangoutTextField.placeholder = "Name Your Party"
 //                                    }
 //
 //                                    alertVC.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: { () -> Void in
 //                                        print("Capture action Cancel")
 //                                    }))
 //
 //                                    alertVC.addAction(PMAlertAction(title: "OK", style: .default, action: { () in
 //                                        print("Capture action OK")
 //
 //                                        self.startHangout(hangoutName: "Hangout", host: Auth.auth().currentUser!, coordinate: self.mapView.userLocation.coordinate, guests: self.guestArray)
 //                                        UpdateService.instance.updateHangoutTitle(title: (self.hangoutTextField.text)!)
 //                                        UpdateService.instance.updateUserIsInHangoutStatus(bool: true, passedUser: Auth.auth().currentUser!)
 //                                        print("Party Sucessfully Started")
 //                                    }))
 //
 //                                    self.present(alertVC, animated: true, completion: nil)
 //                                }
 //                                else
 //                                {
 //                                    print("something is wrong")
 //                                    let alertVC = PMAlertController(title: "End Hangout?", description: "Ending hangout will close any location services for guests", image: UIImage(named: ""), style: .alert)
 //
 //                                    alertVC.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: { () -> Void in
 //                                        print("Capture action Cancel")
 //                                    }))
 //
 //                                    alertVC.addAction(PMAlertAction(title: "OK", style: .default, action: { () in
 //                                        print("Capture action OK")
 //
 //                                        self.endHangout(host: Auth.auth().currentUser!)
 //                                        UpdateService.instance.updateUserIsInHangoutStatus(bool: false, passedUser: Auth.auth().currentUser!)
 //                                        print("Party Sucessfully Ended")
 //                                    }))
 //
 //                                    self.present(alertVC, animated: true, completion: nil)
 //
 //                                }
 //                            }
 //                        }
 //                    }
 //                })
 //            }
 //            else
 //            {
 //                DataService.instance.REF_HANGOUT.observeSingleEvent(of: .value, with: { (snapshot) in
 //                    if let hangoutSnapshot = snapshot.children.allObjects as? [DataSnapshot]
 //                    {
 //                        for hangout in hangoutSnapshot
 //                        {
 //                            if hangout.childSnapshot(forPath: "owner").value as? String == Auth.auth().currentUser?.uid
 //                            {
 //                                if hangout.childSnapshot(forPath: "hangoutIsActive").value as? Bool == true
 //                                {
 //                                    // End Party Functionality
 //                                    let alertVC = PMAlertController(title: "End Hangout?", description: "Ending hangout will close any location services for guests", image: UIImage(named: ""), style: .alert)
 //
 //                                    alertVC.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: { () -> Void in
 //                                        print("Capture action Cancel")
 //                                    }))
 //
 //                                    alertVC.addAction(PMAlertAction(title: "OK", style: .default, action: { () in
 //                                        print("Capture action OK")
 //
 //                                        self.endHangout(host: Auth.auth().currentUser!)
 //                                        UpdateService.instance.updateUserIsInHangoutStatus(bool: false, passedUser: Auth.auth().currentUser!)
 //                                        print("Party Sucessfully Ended")
 //                                    }))
 //
 //                                    self.present(alertVC, animated: true, completion: nil)
 //                                }
 //                                else
 //                                {
 //                                    print("hangout is not active")
 //
 //                                    self.actionBtn.animateButton(shouldLoad: true, withMessage: nil)
 //
 //                                    let alertVC = PMAlertController(title: "Let's Hangout?", description: "Let's let everyone know what's up", image: UIImage(named: ""), style: .alert)
 //
 //
 //                                    alertVC.addTextField { (textField) in
 //                                        self.hangoutTextField = textField!
 //                                        self.hangoutTextField.placeholder = "Name Your Party"
 //                                    }
 //
 //                                    alertVC.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: { () -> Void in
 //                                        print("Capture action Cancel")
 //                                    }))
 //
 //                                    alertVC.addAction(PMAlertAction(title: "OK", style: .default, action: { () in
 //                                        print("Capture action OK")
 //
 //                                        self.startHangout(hangoutName: "Hangout", host: Auth.auth().currentUser!, coordinate: self.mapView.userLocation.coordinate, guests: self.guestArray)
 //                                        UpdateService.instance.updateHangoutTitle(title: (self.hangoutTextField.text)!)
 //                                        UpdateService.instance.updateUserIsInHangoutStatus(bool: true, passedUser: Auth.auth().currentUser!)
 //                                        print("Party Sucessfully Started")
 //                                    }))
 //
 //                                    self.present(alertVC, animated: true, completion: nil)
 //                                }
 //                            }
 //                        }
 //                    }
 //                })
 //            }
 //
 //        }
 

 
 */
