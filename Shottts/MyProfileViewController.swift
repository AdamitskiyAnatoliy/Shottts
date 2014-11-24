//
//  MyProfileViewController.swift
//  Shottts
//
//  Created by Anatoliy Adamitskiy on 11/5/14.
//  Copyright (c) 2014 Anatoliy Adamitskiy. All rights reserved.
//

import Foundation
import UIKit

var username:String = "";
var followersURL:String = "";
var followingURL:String = "";

class MyProfileViewController: UIViewController, UITableViewDelegate, UIActionSheetDelegate {
    
    var userShotsCell:UINib = UINib(nibName: "MyProfileShotsTableViewCell", bundle: nil);
    var followersFollowingVC:FollowersFollowingViewController = FollowersFollowingViewController();
    var profileAvatarURL:[String] = [];
    var loadedProfileAvatar:[String:UIImage] = [String:UIImage]();
    var profileName:String = "";
    var profileLocation:String = "";
    var profileFollowers:String = "";
    var profileFollowing:String = "";
    var profileShots:String = "";
    
    // MARK: ------------
    // MARK: Outlets
    // MARK: ------------
    
    @IBOutlet weak var avatarLarge: UIImageView!
    @IBOutlet weak var usersName: UILabel!
    @IBOutlet weak var usersLocation: UILabel!
    @IBOutlet weak var numberOfFollowers: UILabel!
    @IBOutlet weak var numberOfFollowing: UILabel!
    @IBOutlet weak var numberOfUserShots: UILabel!
    @IBOutlet weak var userShotsTableView: UITableView!
    @IBOutlet weak var followersButton: UIButton!
    @IBOutlet weak var followingButton: UIButton!
    
    // MARK: ------------
    // MARK: ViewDidLoad
    // MARK: ------------
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        loadUserProfile(username)
        
        avatarLarge.layer.cornerRadius = 87.0;
        avatarLarge.layer.masksToBounds = true;
        avatarLarge.layer.borderWidth = 2.0;
        avatarLarge.layer.borderColor = UIColor.whiteColor().CGColor;
        
        self.navigationItem.rightBarButtonItem?.title = "Log Out";
        
        userShotsTableView.registerNib(userShotsCell, forCellReuseIdentifier: "cell");
        
    }
    
    
    func loadUserProfile(userA: String) {
        
        profileAvatarURL = [];
        loadedProfileAvatar = [String:UIImage]();
        
        var userUrl:NSURL = NSURL(string: "https://api.dribbble.com/v1/users/\(userA)?access_token=e7b2183f84ce00d570340c486be45c8c2a795ed95a2cc3191209356eebfbd370")!;
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(userUrl) { [unowned self] (data, response, error) in
            let json = JSON(data: data);
            
            if let avatar = json["avatar_url"].string {
                self.profileAvatarURL.append(avatar);
            }
            
            if let name = json["name"].string {
                self.profileName = name;
            }
            
            if let location = json["location"].string {
                self.profileLocation = location;
            }
            
            if let followers = json["followers_count"].int {
                self.profileFollowers = String(followers);
            }
            
            if let following = json["followings_count"].int {
                self.profileFollowing = String(following);
            }
            
            if let shots = json["shots_count"].int {
                self.profileShots = String(shots);
            }
            
            if let followers_url = json["followers_url"].string {
                followersURL = followers_url;
            }
            
            if let following_url = json["following_url"].string {
                followingURL = following_url;
            }
            
            
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), { () -> Void in
                
                for proAvatar in self.profileAvatarURL {
                    self.loadedProfileAvatar[proAvatar] = UIImage(data: NSData(contentsOfURL: NSURL(string: proAvatar)!)!);
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.userShotsTableView.reloadData();
                    self.avatarLarge.image = self.loadedProfileAvatar[self.profileAvatarURL[0]];
                    self.usersName.text = self.profileName;
                    self.usersLocation.text = self.profileLocation;
                    self.numberOfFollowers.text = self.profileFollowers;
                    self.numberOfFollowing.text = self.profileFollowing;
                    self.numberOfUserShots.text = self.profileShots;
                    
                })
            })
        }
        
        task.resume();
    }
    
    
    
    // MARK: ------------
    // MARK: User Shots Table View
    // MARK: ------------
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10;
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: MyProfileShotsTableViewCell = userShotsTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as MyProfileShotsTableViewCell
        
        return cell;
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 275.0;
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    // MARK: ------------
    // MARK: Actions
    // MARK: ------------
    
    @IBAction func viewFollowers(sender: UIButton) {
        Title = "Followers";
        
        category = "Followers";
        url = followersURL;
        
        let fF = self.storyboard?.instantiateViewControllerWithIdentifier("FollowersFollowingViewController") as FollowersFollowingViewController;
        self.navigationController?.pushViewController(fF, animated: true);
    }
    
    @IBAction func viewFollowing(sender: UIButton) {
        Title = "Following";
        
        category = "Following";
        url = followingURL;
        
        let fF = self.storyboard?.instantiateViewControllerWithIdentifier("FollowersFollowingViewController") as FollowersFollowingViewController;
        self.navigationController?.pushViewController(fF, animated: true);
    }

    @IBAction func logOut(sender: UIButton) {
        
        let logOutConfirm:UIActionSheet = UIActionSheet(title: "Are you sure want to log out?", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Log Out");
        
        logOutConfirm.showInView(self.view);
    }
    
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        
        if buttonIndex == 0 {
            
            isUserLoggedIn = false;
            
            var saveLog:NSUserDefaults = NSUserDefaults.standardUserDefaults();
            
            var savedUser:String = "";
            var loggedIn:Bool = isUserLoggedIn;
            
            saveLog.setObject(savedUser, forKey: "savedUser");
            saveLog.setObject(loggedIn, forKey: "loggedIn");
            
            saveLog.synchronize();

            
            self.navigationController?.popToRootViewControllerAnimated(true);
            
        }
        
    }
    
}