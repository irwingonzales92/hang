//
//  LeftSidePanelVC.swift
//  Hitchhiker-Dev
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
        
        sessionSwitch.isOn = false
        sessionSwitch.isHidden = true
        sessionLbl.isHidden = true
        
        observeUsersAndParties()
        
        // If User has no profile
        if Auth.auth().currentUser == nil
        {
            self.userEmailLbl.text = ""
            self.userAcctTyleLbl.text = ""
            self.userImageView.isHidden = true
            self.sessionSwitch.isHidden = true
            self.sessionLbl.isHidden = true
            self.signinOutBtn.setTitle("Sign Up", for: .normal)
        }
        else
        {
            self.userEmailLbl.text = Auth.auth().currentUser?.email
            self.userAcctTyleLbl.text = ""
            self.userImageView.isHidden = false
            self.signinOutBtn.setTitle("Sign Out", for: .normal)
        }
    }
    
    //Observer Function
    func observeUsersAndParties()
    {
        DataService.instance.REF_USERS.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]
            {
                for snap in snapshot
                {
                    if snap.key == Auth.auth().currentUser?.uid
                    {
                        self.userAcctTyleLbl.text = "USER"
//                        
//                        self.sessionSwitch.isHidden = false
//                        
//                        let switchStatus = snap.childSnapshot(forPath: "isSessionModeEnabled").value as! Bool
//                        self.sessionSwitch.isOn = switchStatus
//                        self.sessionLbl.isHidden = false
                    }
                }
            }
        })
        
        DataService.instance.REF_PARTY.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]
            {
                for snap in snapshot
                {
                    if snap.key == Auth.auth().currentUser?.uid
                    {
                       self.userAcctTyleLbl.text = "PARTY"

                    }
                }
            }
        })
    }
    
    @IBAction func partyBtnPressed(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let partyVC = storyboard.instantiateViewController(withIdentifier: "PartyVC") as? PartyVC
        present(partyVC!, animated: true, completion: nil)
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
                userEmailLbl.text = ""
                userAcctTyleLbl.text = ""
                userImageView.isHidden = true
                sessionLbl.text = ""
                sessionSwitch.isHidden = true
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
