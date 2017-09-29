 //
//  FriendSearchCell.swift
//  
//
//  Created by Irwin Gonzales on 9/3/17.
//
//

import UIKit
import PMAlertController

class FriendSearchCell: UITableViewCell {

    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var addFriendToPartyButton: UIButton!
    @IBOutlet var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected == true
        {

        }
    }
    
    func configureCell(email: String)
    {
        self.usernameLabel.text = email
    }
    
    @IBAction func inviteFriendOnBtnPressed(_ sender: Any)
    {

    }

    // ATTEMPT #1
    
//    func showAlertWhenCellIsSelectedWithCompletion(controller: PMAlertController, guestArray: [String], matchingFriend: String, indexPath: IndexPath)
//    {
//        let alertVC = controller(title: "Add Firend?", description: "Your friend will be able to see your location in real time", image: UIImage(named: ""), style: .alert)
//        
//        alertVC.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: { () -> Void in
//            print("Capture action Cancel")
//        }))
//        
//        alertVC.addAction(PMAlertAction(title: "OK", style: .default, action: { () in
//            UpdateService.instance.addUsersIntoGuestList(users: self.guestArray)
//            
//            print("Capture action OK")
//            print("Friend is added!")
//            
//            guestArray.insert(matchingFriend, at: indexPath)
//            self.dismiss(animated: true, completion: nil)
//        }))
//    }
    
    // ATTEMPT #2
    
    func showAlertController(viewController: UIViewController, alertController: PMAlertController, guestArray: Array
        <String>, matchingFriend: String, indexPath: IndexPath)
    {
        let alertController = PMAlertController(title: "Add Firend?", description: "Your friend will be able to see your location in real time", image: UIImage(named: ""), style: .alert)
        
        alertController.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: { () -> Void in
            print("Capture action Cancel")
        }))
        
        alertController.addAction(PMAlertAction(title: "OK", style: .default, action: { () in
            UpdateService.instance.addUsersIntoGuestList(users: guestArray)
            
            print("Capture action OK")
            print("Friend is added!")
            
            var array = [String]()
            
            array.insert(matchingFriend, at: indexPath.row)
            array = guestArray
            
            viewController.dismiss(animated: true, completion: nil)
        }))
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    
}
