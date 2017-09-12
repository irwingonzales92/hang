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
    private var _REF_HANGOUT = DB_BASE.child("hangout")
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
    
    func createFirebaseDBUsers(uid: String, userData: Dictionary<String, Any>, isHangout: Bool)
    {
        REF_USERS.child(uid).updateChildValues(userData)
        
    }
    
    func createFirebaseDBHangout(uid: String, hangoutData: Dictionary<String, Any>, hangoutName: String, isHangout: Bool, guests: Array<Any>)
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
        REF_USERS.observe(.value, with: { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
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
                
            }
            DispatchQueue.main.async {
                handler(userArray)
            }
            
        })
        }
    }
        
//    func readUserData()
//    {
//        REF_USERS.child("username").observe(.value, with: { (DataSnapshot) in
//            <#code#>
//        })
//    }
}
