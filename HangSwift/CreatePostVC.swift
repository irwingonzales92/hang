//
//  CreatePostVC.swift
//  
//
//  Created by Irwin Gonzales on 8/22/17.
//
//

import UIKit

class CreatePostVC: UIViewController {

    @IBOutlet var sendButton: UIButton!
    @IBOutlet var textView: UITextView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var userProfileImage: UIImageView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.textView.delegate = self

        // Do any additional setup after loading the view.
    }

    @IBAction func cancelBtnPressed(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func sendBtnWasPressed(_ sender: Any) {
    }

}

extension CreatePostVC: UITextViewDelegate
{
    private func textViewDidBeginEditing(_ textView: UITextField)
    {
        self.textView.text = ""
    }
}
