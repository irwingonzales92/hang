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
    
    func getUser(forSearchQuery query:String, handler:@escaping (_ userArray: [String]) -> ())
    {
        var userArray = [String]()
        
        REF_USERS.observe(.value, with: { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for user in userSnapshot
            {
                let username = user.childSnapshot(forPath: "username").value as! String
                
                if username.contains(query) && username != Auth.auth().currentUser?.value(forKey: username) as! String
                {
                    userArray.append(username)
                    
                }
                
            }
            handler(userArray)
        })
    }
    
}
