//
//  MainShotsTableViewCell.swift
//  Shottts
//
//  Created by Anatoliy Adamitskiy on 11/5/14.
//  Copyright (c) 2014 Anatoliy Adamitskiy. All rights reserved.
//

import Foundation
import UIKit

class MainShotsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainShotImageView: UIImageView!
    @IBOutlet weak var mainAvatarImageView: UIImageView!
    var hasImage : Bool = false;
    
    override func awakeFromNib() {
        
        mainAvatarImageView.layer.cornerRadius = 25.0;
        mainAvatarImageView.layer.masksToBounds = true;
        mainAvatarImageView.layer.borderWidth = 1.5;
        mainAvatarImageView.layer.borderColor = UIColor.whiteColor().CGColor;
        mainAvatarImageView.backgroundColor = UIColor.whiteColor();
        hasImage = false;
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated);
    }
    
}