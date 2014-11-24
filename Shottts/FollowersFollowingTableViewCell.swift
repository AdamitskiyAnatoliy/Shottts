//
//  FollowersFollowingTableViewCell.swift
//  Shottts
//
//  Created by Anatoliy Adamitskiy on 11/9/14.
//  Copyright (c) 2014 Anatoliy Adamitskiy. All rights reserved.
//

import Foundation
import UIKit

class FollowersFollowingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var usersName: UILabel!
    
    override func awakeFromNib() {
        
        userAvatar.layer.cornerRadius = 25.0;
        userAvatar.layer.masksToBounds = true;
        userAvatar.layer.borderWidth = 1.0;
        userAvatar.layer.borderColor = UIColor.whiteColor().CGColor;
        
        usersName.text = "Test User";
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated);
    }
    
}