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
    private var _REF_PARTY = DB_BASE.child("party")
    private var _REF_SESSIONS = DB_BASE.child("sessions")
    
    var REF_BASE: DatabaseReference
    {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference
    {
        return _REF_USERS
    }
    
    var REF_PARTY: DatabaseReference
    {
        return _REF_PARTY
    }
    
    var REF_SESSIONS: DatabaseReference
    {
        return _REF_SESSIONS
    }
    
    func createFirebaseDBUsers(uid: String, userData: Dictionary<String, Any>, username: String, isParty: Bool)
    {
        REF_USERS.child(uid).updateChildValues(userData)
        
        
//        if isParty
//        {
//            REF_PARTY.child(uid).updateChildValues(userData)
//        }
//        else
//        {
//            REF_USERS.child(uid).updateChildValues(userData)
//        }
    }
    
    func createFirebaseDBParty(uid: String, partyData: Dictionary<String, Any>, partyname: String, isParty: Bool, guests: Array<Any>)
    {
        REF_PARTY.child(uid).updateChildValues(partyData)
    }
    
}
