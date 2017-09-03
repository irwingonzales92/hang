//
//  CreatePostVC.swift
//  
//
//  Created by Irwin Gonzales on 8/22/17.
//
//

import UIKit
import Firebase

class CreatePostVC: UIViewController {

    @IBOutlet var sendButton: UIButton!
    @IBOutlet var textView: UITextView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.textView.delegate = self
    }

    @IBAction func cancelBtnPressed(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func sendBtnWasPressed(_ sender: Any)
    {
        if textView.text != nil && textView.text != "Say something here..."
        {
            self.sendButton.isEnabled = false
            DataService.instance.updatePost(withMessage: self.textView.text, forUID: (Auth.auth().currentUser?.uid)!, withGroupKey: nil, sendComplete: { (isComplete) in
                if isComplete == true
                {
                    self.sendButton.isEnabled = true
                    self.dismiss(animated: true, completion: nil)
                    print("Post Successfully Saved")
                }
                else
                {
                    self.sendButton.isEnabled = true
                    print("There was an error!")
                }
            })
        }
    }

}

extension CreatePostVC: UITextViewDelegate
{
    private func textViewDidBeginEditing(_ textView: UITextField)
    {
        self.textView.text = ""
        
    }
}
