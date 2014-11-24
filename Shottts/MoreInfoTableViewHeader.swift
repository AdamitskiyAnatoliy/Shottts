//
//  MoreInfoTableViewHeader.swift
//  Shottts
//
//  Created by Anatoliy Adamitskiy on 11/9/14.
//  Copyright (c) 2014 Anatoliy Adamitskiy. All rights reserved.
//

import Foundation
import UIKit

var moreInfoMainAvatarImage:UIImage!
var playerName:String = "";
var descriptionString:String = "";
var commentString:String = "";
var likeString:String = "";
var viewString:String = "";

class MoreInfoTableViewHeader: UITableViewHeaderFooterView {
    
    @IBOutlet weak var playerShotAvatar: UIImageView!
    @IBOutlet weak var playersName: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var viewCount: UILabel!
    
    override func awakeFromNib() {
        
        playerShotAvatar.layer.cornerRadius = 50.0;
        playerShotAvatar.layer.masksToBounds = true;
        playerShotAvatar.layer.borderWidth = 1.5;
        playerShotAvatar.layer.borderColor = UIColor.whiteColor().CGColor;
        playerShotAvatar.image = moreInfoMainAvatarImage;
        playersName.text = playerName;
        desc.text = descriptionString;
        commentCount.text = commentString;
        likeCount.text = likeString;
        viewCount.text = viewString;
        
    }
    
    
    @IBAction func like(sender: UIButton) {
        
        if sender.currentBackgroundImage == UIImage(named: "LikedIcon@2x.png") {
            sender.setBackgroundImage(UIImage(named: "LikeIcon@2x.png"), forState: UIControlState.Normal);
            likeCount.text = String(likeString.toInt()! - 1)
            likeString = String(likeString.toInt()! - 1)
        } else {
            sender.setBackgroundImage(UIImage(named: "LikedIcon@2x.png"), forState: UIControlState.Normal);
            likeCount.text = String(likeString.toInt()! + 1)
            likeString = String(likeString.toInt()! + 1)
        }
        
    }
    
}