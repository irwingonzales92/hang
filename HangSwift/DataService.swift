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
    private var _REF_SESSIONS = DB_BASE.child("sessions")
    
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
    
    var REF_SESSIONS: DatabaseReference
    {
        return _REF_SESSIONS
    }
    
    func createFirebaseDBUsers(uid: String, userData: Dictionary<String, Any>, isHangout: Bool)
    {
        REF_USERS.child(uid).updateChildValues(userData)
        
    }
    
    func createFirebaseDBHangout(uid: String, hangoutData: Dictionary<String, Any>, hangoutName: String, isHangout: Bool, guests: Array<Any>)
    {
        REF_HANGOUT.child(uid).updateChildValues(hangoutData)
    }
    
}
