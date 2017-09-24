//
//  UpdateServices.swift
//  HangSwift
//
//  Created by Irwin Gonzales on 7/28/17.
//  Copyright © 2017 Irwin Gonzales. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import MapKit


class UpdateService
{
    static var instance = UpdateService()

    
    //gets the current user's location
    func updateUserLocation(withCoordinate coordinate: CLLocationCoordinate2D)
    {
        DataService.instance.REF_USERS.observeSingleEvent(of: .value, with: { (snapshot) in
            if let userSnapshot = snapshot.children.allObjects as? [DataSnapshot]
            {
                for user in userSnapshot
                {
                    if user.key == Auth.auth().currentUser?.uid
                    {
                    DataService.instance.REF_USERS.child(user.key).updateChildValues([COORDINATE: [coordinate.latitude, coordinate.longitude]])
                    }
                    
//                    //Update destinationCoordinate with Leader's coordinates if they are the leader.
//                    if user.childSnapshot(forPath: "userIsLeader").value as? Bool == true {
//                        DataService.instance.REF_TRIPS.child("destinationCoordinate").updateChildValues([COORDINATE: [coordinate.latitude, coordinate.longitude]])
//                    }
                    
                }
            }
        })
    }
    
    
    func updateTripsWithCoordinatesUponRequest() {
        DataService.instance.REF_USERS.observeSingleEvent(of: .value, with: { (snapshot) in
            if let userSnapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for user in userSnapshot {
                    if user.key == Auth.auth().currentUser?.uid {
                        if user.hasChild(USER_IS_LEADER) {
                            if let userDict = user.value as? Dictionary<String, AnyObject> {
    
                                let destinationArray = userDict[TRIP_COORDINATE] as! NSArray
                                
                                //user.key means it has the trips has same ID as User
                                DataService.instance.REF_TRIPS.child(user.key).updateChildValues(["leaderCoordinate": [destinationArray[0], destinationArray[1]], "userKey": user.key])
                            }
                        }
                    }
                }
            }
        })
    }
    
    
    
    
    
    
    
    func updateHangoutLocationWithCoordinate(coordinate: CLLocationCoordinate2D)
    {
        DataService.instance.REF_HANGOUT.observeSingleEvent(of: .value, with: { (snapshot) in
            if let partySnapshot = snapshot.children.allObjects as? [DataSnapshot]
            {
                for party in partySnapshot
                {
                    if party.key == Auth.auth().currentUser?.uid
                    {
                        if party.childSnapshot(forPath: "isSessionModeEnabled").value as? Bool == true
                        {
                            DataService.instance.REF_HANGOUT.child(party.key).updateChildValues(["coordinate": [coordinate.latitude, coordinate.longitude]])
                        }
                    }
                }
            }
        })
    }
    
    func updateUserIsInHangoutStatus(bool:Bool, passedUser: User)
    {
        DataService.instance.REF_USERS.observeSingleEvent(of: .value, with: { (snapshot) in
            if let userSnapshot = snapshot.children.allObjects as? [DataSnapshot]
            {
                for user in userSnapshot
                {
                    if user.key == passedUser.uid
                    {
                        DataService.instance.REF_USERS.child(user.key).updateChildValues(["userIsInHangout": bool])
                        print("User is in hangout")
                    }
                }
            }
        })
    }
    
    func updateHangoutTitle(title: String)
    {
        DataService.instance.REF_HANGOUT.observeSingleEvent(of: .value, with: { (snapshot) in
            if let hangoutSnapshot = snapshot.children.allObjects as? [DataSnapshot]
            {
                for hangout in hangoutSnapshot
                {
                    DataService.instance.REF_HANGOUT.child(hangout.key).updateChildValues(["hangoutName": title])
                    print("Hangout title updated")
                }
            }
        })
    }
    
    func addUsersIntoGuestList(users: Array<Any>)
    {
        DataService.instance.REF_HANGOUT.observeSingleEvent(of: .value, with: { (snapshot) in
            if let hangoutSnapshot = snapshot.children.allObjects as? [DataSnapshot]
            {
                for hangout in hangoutSnapshot
                {
                    DataService.instance.REF_HANGOUT.child(hangout.key).updateChildValues(["guestList": users])
                    print("Guest List Added")
                }
            }
        })
    }
    
}
