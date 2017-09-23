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
                
                AuthService.instance.registerUser(withEmail: email, Password: password, andUsername: "", userCreationComplete: { (success, error) in
                    if error == nil
                    {
                        
                        self.showAlert("Login Successful")
                        print("User Successfully Logged in")
                    }
                    else
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
//                                        }
                                                            
                                            self.showAlert("Sign Up Successful")
                                            print("User Successfully Signed Up")
                                            
                                                            
                                        }
                                    }
                                })
                            }
                        }
                })
            }
        }
        
        
    }
}
