//
//  LoginVC.swift
//  Hitchhiker-Dev
//
//  Created by Irwin Gonzales on 7/12/17.
//  Copyright © 2017 Irwin Gonzales. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController, UITextFieldDelegate, Alertable {

    @IBOutlet var authBtn: RoundedShadowButton!
    @IBOutlet var passwordTextField: RoundedCornerTextField!
    @IBOutlet var emailTextField: RoundedCornerTextField!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var usernameTextField: RoundedCornerTextField!
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        setupDelegates()
        view.bindToKeyboard()
        
        self.segmentedControl.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleScreenTap(sender:)))
        self.view.addGestureRecognizer(tap)
        
    }
    
    func setupDelegates()
    {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        usernameTextField.delegate = self
    }

    func handleScreenTap(sender: UITapGestureRecognizer)
    {
        self.view.endEditing(true)
    }

    
    @IBAction func cancelBtnWasPressed(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func authBtnWasPressed(_ sender: Any)
    {
        // Checks if textfields are not empty
        if emailTextField.text != nil && passwordTextField.text != nil && usernameTextField.text != nil
        {
            authBtn.animateButton(shouldLoad: true, withMessage: nil)
            self.view.endEditing(true)
            
            // Sets username variable from textfield
            var username = String()
            username = self.usernameTextField.text!
            
            
            // Check textfields for content
            if let email = emailTextField.text, let password = passwordTextField.text
            {
                AuthService.instance.registerUser(withEmail: email, Password: password, andUsername: username, userCreationComplete: { (user, error) in
                    if error == nil
                    {
                        print("Email user authenticated successfully with Firebase")
                        self.dismiss(animated: true, completion: nil)
                    }
                    else
                    {
                        if let errorCode = AuthErrorCode(rawValue: error!._code)
                        {
                            switch errorCode
                            {
                            case .emailAlreadyInUse:
                                self.showAlert("Email is in use")
                                
                            case .wrongPassword:
                                self.showAlert("Wrong Password")
                            case .credentialAlreadyInUse:
                                self.showAlert("Username already taken")
                                
                            default:
                                self.showAlert(error as Any as! String)
                                print(error as Any)
                            }
                        }
                    }
                })
            }
//            {
//                Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
//                    if error == nil
//                    {
//                        // Check if user exists
//                        if let user = user
//                        {
////                            let userData = ["provider": user.providerID, "userIsInParty": false, "userEmail": user.email!, "username": username] as [String: Any]
////                            DataService.instance.createFirebaseDBUsers(uid: user.uid, userData: userData, username: username, isParty: false)
//                            
////                            let userData = ["provider": user.providerID, "userIsParty": true, "isSessionModeEnabled": false, "partyIsInSession": false] as [String: Any]
////                            DataService.instance.createFirebaseDBUsers(uid: user.uid, userData: userData, username: username, isParty: true)
//                            
//                        }
//                        print("Email user authenticated successfully with Firebase")
//                        self.dismiss(animated: true, completion: nil)
//                    }
//                    else
//                    {
//                        if let errorCode = AuthErrorCode(rawValue: error!._code)
//                        {
//                            switch errorCode
//                            {
//                            case .emailAlreadyInUse:
//                                print("That email is already in use, please try again")
//                                
//                            case .wrongPassword:
//                                print("Oops, wrong password")
//                                
//                            case .credentialAlreadyInUse:
//                                print("Username Already Taken")
//                                
//                            default:
//                                print(error as Any)
//                            }
//                        }
//                        
//                        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
//                            if error != nil
//                            {
//                                // Error handels
//                                if let errorCode = AuthErrorCode(rawValue: error!._code)
//                                {
//                                    switch errorCode
//                                    {
//                                    case .emailAlreadyInUse:
//                                        print("That email is already in use, please try again")
//                                        
//                                    case .invalidEmail:
//                                        print("That is an invalid email, please try again")
//                                        
//                                    default:
//                                        //print("Oops, something wrong happened")
//                                        print(error as Any)
//                                        
//                                    }
//                                }
//                            }
//                            else
//                            {
//                                if let user = user
//                                {
//
////                                    let userData = ["provider": user.providerID, "userIsInParty": false, "userEmail": self.emailTextField.text!, "username": username] as [String: Any]
////                                    DataService.instance.createFirebaseDBUsers(uid: user.uid, userData: userData, username: username, isParty: false)
//
////                                        let userData = ["provider": user.providerID, "userIsParty": true, "isSessionModeEnabled": false, "partyIsOnSession": false] as [String: Any]
////                                        DataService.instance.createFirebaseDBUsers(uid: user.uid, userData: userData, username: username, isParty: true)
//
//                                }
//                                
//                                print("Successfully created a new user with Firebase")
//                                self.dismiss(animated: true, completion: nil)
//                            }
//                        })
//                    }
//                    
//                })
//            }
        }
    }

}
