//
//  FriendSearchCell.swift
//  
//
//  Created by Irwin Gonzales on 9/3/17.
//
//

import UIKit

class FriendSearchCell: UITableViewCell {

    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var addFriendToPartyButton: UIButton!
    @IBOutlet var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(email: String)
    {
        self.usernameLabel.text = email
    }
    
}
