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
    
    func updateUserLocationWithCoordinate(coordinate: CLLocationCoordinate2D)
    {
        DataService.instance.REF_USERS.observeSingleEvent(of: .value, with: { (snapshot) in
            if let userSnapshot = snapshot.children.allObjects as? [DataSnapshot]
            {
                for user in userSnapshot
                {
                    if user.key == Auth.auth().currentUser?.uid
                    {
                        DataService.instance.REF_USERS.child(user.key).updateChildValues(["coordinate": [coordinate.latitude, coordinate.longitude]])
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
}
