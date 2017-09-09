//
//  FriendSearchVC.swift
//  HangSwift
//
//  Created by Irwin Gonzales on 9/9/17.
//  Copyright © 2017 Irwin Gonzales. All rights reserved.
//

import UIKit

class FriendSearchVC: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var friendSearchTextField: UITextField!
    
    var friendArray = [String]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        friendSearchTextField.delegate = self
        friendSearchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange()
    {
        if friendSearchTextField.text == ""
        {
            friendArray = []
            tableView.reloadData()
        }
        else
        {
            DataService.instance.getUser(forSearchQuery: friendSearchTextField.text!, handler: { (userArray) in
                self.friendArray = userArray
                self.tableView.reloadData()
            })
        }
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any)
    {
        
    }
}

extension FriendSearchVC: UITextFieldDelegate
{

    
}

extension FriendSearchVC: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? FriendSearchCell else {return UITableViewCell()}
        
        cell.configureCell(email: friendSearchTextField.text!)
        return cell
    }
}

