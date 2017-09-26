//
//  LeftSidePanelVC.swift
//  
//
//  Created by Irwin Gonzales on 7/8/17.
//  Copyright © 2017 Irwin Gonzales. All rights reserved.
//

import UIKit
import Firebase

class LeftSidePanelVC: UIViewController {

    @IBOutlet var userEmailLbl: UILabel!
    @IBOutlet var userAcctTyleLbl: UILabel!
    @IBOutlet var userImageView: RoundImageView!
    @IBOutlet var signinOutBtn: UIButton!
    @IBOutlet var sessionSwitch: UISwitch!
    @IBOutlet var sessionLbl: UILabel!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
    }
    

    @IBAction func partyBtnPressed(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let hangoutVC = storyboard.instantiateViewController(withIdentifier: "HangoutVC") as? HangoutVC
        present(hangoutVC!, animated: true, completion: nil)
    }
    @IBAction func inviteFriendBtnPressed(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let friendSearchVC = storyboard.instantiateViewController(withIdentifier: "FriendSearchVC") as? FriendSearchVC
        present(friendSearchVC!, animated: true, completion: nil)
    }
    
    @IBAction func acntBtnPressed(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC
        present(profileVC!, animated: true, completion: nil)
    }
    @IBAction func signupLoginBtnPressed(_ sender: Any)
    {
        if Auth.auth().currentUser == nil
        {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
            present(loginVC!, animated: true, completion: nil)
        }
        else
        {
            do
            {
                try Auth.auth().signOut()
                signinOutBtn.setTitle("Sign In", for: .normal)
            }
            catch (let error)
            {
                print(error)
            }
        }
    }

    @IBAction func accountButtonPressed(_ sender: Any)
    {
        performSegue(withIdentifier: "accountSegue", sender: Any?.self)
    }
    

}
