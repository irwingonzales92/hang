//
//  PartyVC.swift
//  HangSwift
//
//  Created by Irwin Gonzales on 8/16/17.
//  Copyright © 2017 Irwin Gonzales. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class PartyVC: UIViewController {
    
    var guestList = Array<Any>()

    var tableView = UITableView()
    
    var eventCell = EventTitleCell()
    var customImageCell = CustomImageCell()
    var descriptionCell = DescriptionCell()
    var customMapCell = CustomMapCell()
    var guestListCell = GuestListCell()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

//        setDelegatesAndDataSource()
    }
    
//    func setDelegatesAndDataSource()
//    {
//        tableView.delegate = self as? UITableViewDelegate
//        tableView.dataSource = self as? UITableViewDataSource
//    }

    func startParty(partyName: String, host: User, guests: Array<Any>)
    {
        DataService.instance.REF_PARTY.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.children.allObjects is [DataSnapshot]
            {
                if host.uid == Auth.auth().currentUser?.uid
                {
                    
                    let partyData = [ "partyName": partyName, "provider": host.providerID, "desciption": String(), "partyIsActive": Bool(), "startTime": ServerValue.timestamp()] as [String : Any]
                    
                    DataService.instance.createFirebaseDBParty(uid: host.uid, partyData: partyData, partyname: partyName, isParty: true, guests: guests)
                }
            }
        })
    }
    
    func addUserToInviteList()
    {
        
    }
    
    func deleteUserFromInviteList()
    {
        
    }
    
}

extension PartyVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        return guestListCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
//        animateTableView(shouldShow: false)
//        print("selelcted")
        
        // Add Alert View that allows users to invite friends to hang out.
        
    }

}


