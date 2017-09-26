//
//  DataService.swift
//  HangSwift
//
//  Created by Irwin Gonzales on 7/15/17.
//  Copyright © 2017 Irwin Gonzales. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()

class DataService
{
    static let instance = DataService()
    var userSnapshot: DataSnapshot?
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_HANGOUT = DB_BASE.child("hangouts")
    private var _REF_FEED = DB_BASE.child("feed")
    
    
    var REF_BASE: DatabaseReference
    {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference
    {
        return _REF_USERS
    }
    
    var REF_HANGOUT: DatabaseReference
    {
        return _REF_HANGOUT
    }
    
    var REF_FEED: DatabaseReference
    {
        return _REF_FEED
    }
    
    
    
    func createFirebaseDBUsers(uid: String, userData: Dictionary<String, Any>, isLeader: Bool)
    {
        REF_USERS.child(uid).updateChildValues(userData)
        
    }
    
    func createFirebaseDBHangout(uid: String, hangoutData: Dictionary<String, Any>, hangoutName: String, isHangout: Bool)
    {
        REF_HANGOUT.child(uid).updateChildValues(hangoutData)
    }
    
    func endFirebaseDBHangout(uid: String, hangoutData: Dictionary<String, Any>)
    {
        REF_HANGOUT.child(uid).updateChildValues(hangoutData)
    }
    
    func updatePost(withMessage message: String, forUID uid: String, withGroupKey groupKey: String?, sendComplete: @escaping(_ status: Bool) -> ())
    {
        if groupKey != nil
        {
            // send group ref
        }
        else
        {
            REF_FEED.childByAutoId().updateChildValues(["content": message, "senderID": uid])
            sendComplete(true)
        }
    }
    
    func getUser(forSearchQuery query: String, handler:@escaping (_ userArray: [String]) -> ())
    {
        var userArray = [String]()
        if let theSnapshot = userSnapshot {
            guard let userSnapshot = theSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for user in userSnapshot
            {
                if let userEmail = user.childSnapshot(forPath: "userEmail").value as? String {
                    
                    if userEmail.contains(query) == true && userEmail != Auth.auth().currentUser?.email
                    {
                        userArray.append(userEmail)
                    }
                    else
                    {
                        print("query not found")
                    }
                }
                
                /*
                if let user = Auth.auth().currentUser {
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = "My name"
                    changeRequest.commitChanges(completion: nil)
                }
                */
                
            }
            DispatchQueue.main.async {
                handler(userArray)
            }
        }
        else
        {
            
        /*
             Bug Fix Theory: The reason why the tableview keeps reloading is because
             that it is constantly being observed. Try chaning the methods of "Observe"
             with "ObserveWithSingleEvent"
        */
          
        REF_USERS.observeSingleEvent(of: .value, with: { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for user in userSnapshot
            {
                if let userEmail = user.childSnapshot(forPath: "userEmail").value as? String
                {
                    if userEmail.contains(query) == true && userEmail != Auth.auth().currentUser?.email
                    {
                        userArray.append(userEmail)
                    }
                    else
                    {
                        print("Query not found")
                    }
                }
            }
            
            DispatchQueue.main.async {
                handler(userArray)
            }
        })
        
            
//        REF_USERS.observe(.value, with: { (userSnapshot) in
//            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
//            for user in userSnapshot
//            {
//                if let userEmail = user.childSnapshot(forPath: "userEmail").value as? String {
//                    
//                    if userEmail.contains(query) == true && userEmail != Auth.auth().currentUser?.email
//                    {
//                        userArray.append(userEmail)
//                    }
//                    else
//                    {
//                        print("query not found")
//                    }
//                }
//            }
//            DispatchQueue.main.async {
//                handler(userArray)
//            }
//        })
        }
    }
    
    func checkIfUserIsInHangout(passedUser: User, handler:@escaping (_ isInside: Bool) -> Void)
    {
        DataService.instance.REF_USERS.observeSingleEvent(of: .value, with: { (snapshot) in
            if let userSnapshot = snapshot.children.allObjects as? [DataSnapshot]
            {
                for user in userSnapshot
                {
                    if user.key == passedUser.uid
                    {
                        if user.childSnapshot(forPath: "userIsInHangout").value as? Bool == true
                        {
                            print("Hangout Annotation Displayed")
                            handler(true)
                        }
                        else
                        {
                            print("User Annotation Displayed")
                            handler(false)
                        }
                    }
                }
            }
        })
    }
    
    
    func userIsAvailableForHangout(key: String, handler: @escaping (_ status: Bool?) -> Void) {
        DataService.instance.REF_USERS.observeSingleEvent(of: .value, with: { (snapshot) in
            if let userSnapshot = snapshot.children.allObjects as? [DataSnapshot]
            {
                for user in userSnapshot
                {
                    if user.key == key
                    {
                            if user.childSnapshot(forPath: "userIsInHangout").value as? Bool == true
                            {
                                handler(false)
                            }
                            else
                            {
                                handler(true)
                            }
                    }
                }
            }
        })
    }

    

    
    func userIsLeader(userKey: String, handler: @escaping (_ status: Bool) -> Void) {
        DataService.instance.REF_USERS.observeSingleEvent(of: .value, with: { (leaderSnapshot) in
            if let leaderSnapshot = leaderSnapshot.children.allObjects as? [DataSnapshot] {
                for leader in leaderSnapshot {
                    if leader.childSnapshot(forPath: "userIsLeader").value as? Bool == true {
                        handler(true)
                    } else {
                        handler(false)
                    }
                }
            }
        })
    }
    
    
    func userIsGuest(userKey: String, handler: @escaping (_ status: Bool) -> Void) {
        DataService.instance.REF_USERS.observeSingleEvent(of: .value, with: { (guestSnapshot) in
            if let guestSnapshot = guestSnapshot.children.allObjects as? [DataSnapshot] {
                for guest in guestSnapshot {
                    if guest.childSnapshot(forPath: "userIsGuest").value as? Bool == true {
                        handler(true)
                    } else {
                        handler(false)
                    }
                }
            }
        })
    }
    
    
    
    
}
