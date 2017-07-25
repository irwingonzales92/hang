//
//  DataService.swift
//  Hitchhiker-Dev
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
    private var _REF_MUSICIANS = DB_BASE.child("musicians")
    private var _REF_JAMSESSIONS = DB_BASE.child("sessions")
    
    var REF_BASE: DatabaseReference
    {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference
    {
        return _REF_USERS
    }
    
    var REF_MUSICIANS: DatabaseReference
    {
        return _REF_MUSICIANS
    }
    
    var REF_JAMSESSIONS: DatabaseReference
    {
        return _REF_JAMSESSIONS
    }
    
    func createFirebaseDBUsers(uid: String, userData: Dictionary<String, Any>, isMusician: Bool)
    {
        if isMusician
        {
            REF_MUSICIANS.child(uid).updateChildValues(userData)
        }
        else
        {
            REF_USERS.child(uid).updateChildValues(userData)
        }
    }
    
    
}
