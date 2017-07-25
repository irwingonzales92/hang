//
//  LoginVC.swift
//  Hitchhiker-Dev
//
//  Created by Irwin Gonzales on 7/12/17.
//  Copyright © 2017 Irwin Gonzales. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController, UITextFieldDelegate {

    @IBOutlet var authBtn: RoundedShadowButton!
    @IBOutlet var passwordTextField: RoundedCornerTextField!
    @IBOutlet var emailTextField: RoundedCornerTextField!
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        setupDelegates()
        view.bindToKeyboard()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleScreenTap(sender:)))
        self.view.addGestureRecognizer(tap)
        
    }
    
    func setupDelegates()
    {
        emailTextField.delegate = self
        passwordTextField.delegate = self
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
        if emailTextField.text != nil && passwordTextField.text != nil
        {
            authBtn.animateButton(shouldLoad: true, withMessage: nil)
            self.view.endEditing(true)
            
            // Check textfields for content
            if let email = emailTextField.text, let password = passwordTextField.text
            {
                //Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                    if error == nil
                    {
                        // Check if user exists
                        if let user = user
                        {
                            if self.segmentedControl.selectedSegmentIndex == 0
                            {
                                let userData = ["provider": user.providerID] as [String: Any]
                                DataService.instance.createFirebaseDBUsers(uid: user.uid, userData: userData, isMusician: false)
                            }
                            else
                            {
                                let userData = ["provider": user.providerID, "userIsMusician": true, "isSessionModeEnabled": false, "musicianIsInSession": false] as [String: Any]
                                DataService.instance.createFirebaseDBUsers(uid: user.uid, userData: userData, isMusician: true)
                                
                            }
                        }
                        print("Email user authenticated successfully with Firebase")
                        self.dismiss(animated: true, completion: nil)
                    }
                    else
                    {
                        // Creates new users
                        if let errorCode = AuthErrorCode(rawValue: error!._code)
                        {
                            switch errorCode
                            {
                            case .emailAlreadyInUse:
                                print("That email is already in use, please try again")
                                
                            case .wrongPassword:
                                print("Oops, wrong password")
                                
                            default:
                                print("Oops, something wrong happened")
                            }
                        }
                        
                        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                            if error != nil
                            {
                                // Error handels
                                ///if let errorCode = AuthErrorCode(rawValue: error!._code)
                                if let errorCode = AuthErrorCode(rawValue: error!._code)
                                {
                                    switch errorCode
                                    {
                                    case .emailAlreadyInUse:
                                        print("That email is already in use, please try again")
                                        
                                    case .invalidEmail:
                                        print("That is an invalid email, please try again")
                                        
                                    default:
                                        print("Oops, something wrong happened")
                                        
                                    }
                                }
                            }
                            else
                            {
                                if let user = user
                                {
                                    if self.segmentedControl.selectedSegmentIndex == 0
                                    {
                                        let userData = ["provider": user.providerID] as [String: Any]
                                        DataService.instance.createFirebaseDBUsers(uid: user.uid, userData: userData, isMusician: false)
                                    }
                                    else
                                    {
                                        let userData = ["provider": user.providerID, "userIsMusician": true, "isStartJamModeEnabled": false, "musicianIsOnSession": false] as [String: Any]
                                        DataService.instance.createFirebaseDBUsers(uid: user.uid, userData: userData, isMusician: true)
                                    }
                                }
                                
                                print("Successfully created a new user with Firebase")
                                self.dismiss(animated: true, completion: nil)
                            }
                        })
                    }
                    
//                    else
//                    {
//                        let error: Error
//                        print("There is something wrong \(error)")
//                    }

                })
            }
        }
    }

}
