//
//  LoginVC.swift
//  
//
//  Created by Irwin Gonzales on 7/12/17.
//  Copyright © 2017 Irwin Gonzales. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController, UITextFieldDelegate, Alertable {
    
    let appDelegate = AppDelegate.getAppDelegate()

    @IBOutlet var authBtn: RoundedShadowButton!
    @IBOutlet var passwordTextField: RoundedCornerTextField!
    @IBOutlet var emailTextField: RoundedCornerTextField!
    @IBOutlet var usernameTextField: RoundedCornerTextField!
    @IBOutlet weak var cancelBtn: UIButton!
    
    var username = String()
    var homeVC = HomeVC()
    
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
                
                AuthService.instance.loginUser(withEmail: email, andPassword: password, userLoginComplete: { (success, error) in
                    if error == nil
                    {
                        
                        self.showAlert("Login Successful")
//                        self.startHangout(hangoutName: "", host: Auth.auth().currentUser!)
                        print("User Successfully Logged in")
                        NotificationCenter.default.post(name: Notification.Name.init(rawValue: "UserLoggedIn"), object: nil)
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
                                
                                AuthService.instance.registerUser(withEmail: email, Password: password, andUsername: username, userCreationComplete:
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
                                        self.showAlert("Sign Up Successful")
//                                        self.startHangout(hangoutName: "", host: Auth.auth().currentUser!)
                                        print("User Successfully Signed Up")
                                        NotificationCenter.default.post(name: Notification.Name.init(rawValue: "UserLoggedIn"), object: nil)
                                        
                                    }
                                })
                                
                                
                            }
                        }
                })
            }
        }
        
      appDelegate.MenuContainerVC.toggleLoginVC()
    }
    
//    func startHangout(hangoutName: String, host: User)
//    {
//        let hangoutData = ["provider": host.providerID, "desciption": String(), "hangoutIsActive": true,"hangoutIsPrivate": Bool(), "owner": host.uid, "startTime": ServerValue.timestamp()] as [String : Any]
//        
//        DataService.instance.createFirebaseDBHangout(uid: host.uid, hangoutData: hangoutData, hangoutName: hangoutName, isHangout: true)
//        
//        UpdateService.instance.updateUserIsInHangoutStatus(bool: true, passedUser: Auth.auth().currentUser!)
//    }
    
}
