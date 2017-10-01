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
    
    // PICK UP WORK 1: Modify remove value
    
    // Right now, I'm working on the delete function. Rather than changing the status into inactive
    func endFirebaseDBHangout(uid: String, hangoutData: Dictionary<String, Any>)
    {
//        REF_HANGOUT.child(uid).updateChildValues(hangoutData)
        
        REF_HANGOUT.child(uid).removeValue { (error, ref) in
            if error != nil
            {
                print(error)
            }
            else
            {
                print(ref)
                print("Party Ending Successful")
            }
        }
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
    
    func changeEmailToUid(email: String,  handler:@escaping (_ userUID: String) -> ())
    {
        REF_USERS.child("userEmail").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userSnapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
            for user in userSnapshot
            {
                if let userEmail = user.childSnapshot(forPath: "userEmail").value as? String
                {
                    if userEmail.contains(email) == true
                    {
                        let userId = user.childSnapshot(forPath: "userId").value as? String
                        handler(userId!)
                    }
                    else
                    {
                        print("Email not found")
                    }
                }
            }
        })
    }
    
    //CHANGE TO UID
    func getUser(forSearchQuery query: String, handler:@escaping (_ userArray: [String]) -> ())
    {
        var userArray = [String]()
        if let theSnapshot = userSnapshot {
            guard let userSnapshot = theSnapshot.children.allObjects as? [DataSnapshot] else {return}
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
    
    func guestIsOnTripToLeader(guestKey: String, handler: @escaping (_ status: Bool?, _ guestKey: String?, _ hangoutKey: String?) -> Void) {
        DataService.instance.REF_USERS.child(guestKey).child("userIsInHangout").observe(.value, with: { (userHangoutStatusSnapshot) in
            if let userHangoutStatusSnapshot = userHangoutStatusSnapshot.value as? Bool {
                if userHangoutStatusSnapshot == true {
                    DataService.instance.REF_HANGOUT.observeSingleEvent(of: .value, with: { (hangoutSnapshot) in
                        if let hangoutSnapshot = hangoutSnapshot.children.allObjects as? [DataSnapshot] {
                            for hangout in hangoutSnapshot {
                                if hangout.childSnapshot(forPath: "guestKey").value as? String == guestKey {
                                    handler(true, guestKey, hangout.key)
                                } else {
                                    return
                                }
                            }
                        }
                    })
                } else {
                    handler(false, nil, nil)
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
    
    
    func userIsGuest(guestKey: String, handler: @escaping (_ status: Bool) -> Void) {
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
    
    // Work On After Commit
    
    
//    func checkIfUserIsInGuestList(userEmail: String, handler: @escaping (_ status: Bool) -> Void)
//    {
//        DataService.instance.REF_HANGOUT.observeSingleEvent(of: .value, with: { (snapshot) in
//            if let guestSnapshot = snapshot.children.allObjects as? [DataSnapshot]
//            {
//                for guests in guestSnapshot
//                {
//                    if guests.childSnapshot(forPath: "guestList").value as [String]
//                    {
//                        for
//                    }
//                }
//            }
//        }
//    }
    
}
