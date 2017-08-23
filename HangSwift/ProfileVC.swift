//
//  ProfileVC.swift
//  HangSwift
//
//  Created by Irwin Gonzales on 8/14/17.
//  Copyright © 2017 Irwin Gonzales. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import Firebase

class ProfileVC: UIViewController, UIImagePickerControllerDelegate {

    @IBOutlet var profileImageView: RoundImageView!
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    
    var ref: DatabaseReference!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        
        loadUserInfo()

    }
    
    //Loading Function
    func loadUserInfo()
    {
        self.nameLabel.text = Auth.auth().currentUser?.email
//      self.nameLabel.text = Auth.auth().currentUser?.displayName

    }

    // UI Action
    @IBAction func cancelBtnWasPressed(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    

    // Camera Functions
    @IBAction func editProfileImgBtnPressed(_ sender: Any)
    {
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            let picker = UIImagePickerController()
            picker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.mediaTypes = [kUTTypeImage as String]
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil)
        }
        else{
            NSLog("No Camera.")
            let alert = UIAlertController(title: "No camera", message: "Please allow this app the use of your camera in settings or buy a device that has a camera.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: NSDictionary!)
    {
        NSLog("Received image from camera")
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        var originalImage:UIImage?, editedImage:UIImage?, imageToSave:UIImage?
        let compResult:CFComparisonResult = CFStringCompare(mediaType as NSString!, kUTTypeImage, CFStringCompareFlags.compareCaseInsensitive)
        if ( compResult == CFComparisonResult.compareEqualTo )
        {
            
            editedImage = info[UIImagePickerControllerEditedImage] as! UIImage?
            originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage?
            
            if ( editedImage != nil )
            {
                imageToSave = editedImage
            }
            else
            {
                imageToSave = originalImage
            }
            profileImageView.image = imageToSave
            profileImageView.reloadInputViews()
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // Save Function
    @IBAction func saveBtnPressed(_ sender: Any)
    {
        if nameTextField.text != "" && cityTextField.text != ""
        {
            DataService.instance.REF_USERS.observeSingleEvent(of: .value, with: { (snapshot) in
                if let userSnapshot = snapshot.children.allObjects as? [DataSnapshot]
                {
                    for user in userSnapshot
                    {
                        if user.key == Auth.auth().currentUser?.uid
                        {
                            DataService.instance.REF_USERS.child(user.key).updateChildValues(["username": self.nameTextField.text!, "city": self.cityTextField.text!])
                            
                            self.nameLabel.text = self.nameTextField.text
                            
                            self.dismiss(animated: true, completion:
                                {
                                print("Successfully Saved")
                            })
                        }
                    }
                }
            })
        }
    }
    

}
