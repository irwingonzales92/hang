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
    @IBOutlet var usernameTextField: RoundedCornerTextField!
    @IBOutlet weak var cancelBtn: UIButton!
    
    var username = String()
    var globalFunctions = GlobalFunctions()
    
    override func viewWillAppear(_ animated: Bool)
    {
        if Auth.auth().currentUser == nil
        {
            cancelBtn.isHidden = true
            
        }
    }
    
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
 
        if emailTextField.text != nil && passwordTextField.text != nil && usernameTextField.text != nil
        {
            authBtn.animateButton(shouldLoad: true, withMessage: nil)
            self.view.endEditing(true)
            

            
            username = self.usernameTextField.text!
            
            
            if let email = emailTextField.text, let password = passwordTextField.text
            {
                //IRWIN: YOU CAN SWITCH THIS WITH YOUR SIGNIN FUNCTION IF YOU'D LIKE
                Auth.auth().signIn(withEmail: email, password: password, completion:
                    { (user, error) in
                    if error == nil
                    {
                        if let user = user
                        {
                            let userData = ["provider": user.providerID] as [String: Any]
                                DataService.instance.createFirebaseDBUsers(uid: user.uid, userData: userData, isLeader: false)
                        }
                        //self.dismiss(animated: true, completion: nil)
                        
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                        let homeVC: UIViewController = (storyBoard.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC)!
                        self.present(homeVC, animated: true, completion: nil)
                        
                        self.showAlert("Login Successful")
                        print("User Successfully Logged in")
                    } else
                    {
                        if let errorCode = AuthErrorCode(rawValue: error!._code)
                        {
                            
                            switch errorCode
                            {
                                
                            case .wrongPassword:
                                self.showAlert(ERROR_MSG_WRONG_PASSWORD)
                                
                            default:
                                self.showAlert(ERROR_MSG_UNEXPECTED_ERROR)
                                print(error as Any)
                            }
                        }
                        
                        //IRWIN: YOU CAN SWITCH THIS WITH YOUR REGISTER USER FUNCTION IF YOU'D LIKE
                        if let email = self.emailTextField.text, let password = self.passwordTextField.text, let username = self.usernameTextField.text
                        {
                    
                            Auth.auth().createUser(withEmail: email, password: password, completion:
                                { (user, error) in
                                if error != nil
                                {
                                    
                                    if let errorCode = AuthErrorCode(rawValue: error!._code)
                                    {
                                        
                                        switch errorCode
                                        {
                                        case .emailAlreadyInUse:
                                            self.showAlert("Email is in use")
                                            
                                        case .invalidEmail:
                                            self.showAlert(ERROR_MSG_INVALID_EMAIL)
                                            
                                        default:
                                            self.showAlert(ERROR_MSG_UNEXPECTED_ERROR)
                                            print(error as Any)
                                            debugPrint(error)
                                        }
                                    }
                                }
                                else
                                {
                                    if let user = user
                                    {
                                            let userData = ["provider": user.providerID, USER_IS_LEADER: false] as [String:Any]
                                            DataService.instance.createFirebaseDBUsers(uid: user.uid, userData: userData, isLeader: false)
                                        }
                                    
                                    
                                    
//                                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//                                    let homeVC: UIViewController = (storyBoard.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC)!
//                                    self.present(homeVC, animated: true, completion: nil)
                                    
                                    
                                    self.showAlert("Sign Up Successful")
                                    print("User Successfully Signed Up")
                                    self.dismiss(animated: true, completion: nil)
                                    
                                    }
                                })
                            }
                        }
                    })
                }
            }
            
//            if let email = emailTextField.text, let password = passwordTextField.text, let username = self.usernameTextField.text
//            {
//                AuthService.instance.registerUser(withEmail: email, Password: password, andUsername: username, userCreationComplete: { (user, error) in
//                    if error == nil
//                    {
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
//                                self.showAlert("Email is in use")
//                                
//                            case .wrongPassword:
//                                self.showAlert("Wrong Password")
//                            case .credentialAlreadyInUse:
//                                self.showAlert("Username already taken")
//                                
//                            default:
//                                self.showAlert(error as Any as! String)
//                                print(error as Any)
//                            }
//                        }
//                    }
//                })
//            }
        
        
        }
    
    
    
    }
