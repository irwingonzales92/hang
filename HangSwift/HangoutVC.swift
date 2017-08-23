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

class HangoutVC: UIViewController {
    
    var guestList = Array<Any>()

    var tableView = UITableView()
    
    var eventCell = EventTitleCell()
    var customImageCell = CustomImageCell()
    var descriptionCell = DescriptionCell()
    var customMapCell = CustomMapCell()
    var guestListCell = GuestListCell()
    
    var partyTitle: String?
    var manager: CLLocationCoordinate2D?
    var regionRadius: CLLocationDistance = 500
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

//        setDelegatesAndDataSource()
    }
    
//    func setDelegatesAndDataSource()
//    {
//        
//    }
    
    func addUserToInviteList()
    {
        
    }
    
    func deleteUserFromInviteList()
    {
        
    }
    
//    func centerMapOnUserLocation()
//    {
//        let coordinateRegion = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, regionRadius * 2.0, regionRadius * 2.0)
//        self.mapView.setRegion(coordinateRegion, animated: true)
//    }
    
    
    //    LOCATION SEARCH FUNCTION
    //
    //    func perfomSearch()
    //    {
    //        matchingMapItems.removeAll()
    //
    //        let request = MKLocalSearchRequest()
    //        request.naturalLanguageQuery = locationSearchTextField
    //    }
    
    
    func searchForFriendsWithUsername(username: String) -> String
    {
        DataService.instance.REF_USERS.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.children.allObjects is [DataSnapshot]
            {
                DataService.instance.REF_USERS.queryOrdered(byChild: "username").queryEqual(toValue: username)
            }
        })
        return username
    }
    
//    func addUpdatesToParty(message: String)
//    {
//        DataService
//    }

    
}

extension HangoutVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        switch indexPath.section
        {
        case 0:
            
            customMapCell.backgroundColor = UIColor.blue
            
            
            return customMapCell

            
        case 1:
            
            eventCell.backgroundColor = UIColor.green
            
            return eventCell
            
            
        case 2:
            
            descriptionCell.backgroundColor = UIColor.red
            
            return descriptionCell
            
        case 3:
            
            customImageCell.backgroundColor = UIColor.gray
            
            return customImageCell

            
        case 4:
            
            guestListCell.backgroundColor = UIColor.brown
            
            return guestListCell
            
        default:
            
            let cell = UITableViewCell()
            
            return cell
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 5
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch section
        {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return 1
        case 4:
            return 1
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        switch indexPath.section
        {
        case 0:
            return 200
        case 1:
            return 50
        case 2:
            return 275
        case 3:
            return 75
        case 4:
            return 75
        default:
            return 20
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
//        animateTableView(shouldShow: false)
//        print("selelcted")
        
        // Add Alert View that allows users to invite friends to hang out.
        
    }

}



