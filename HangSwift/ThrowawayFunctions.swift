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


