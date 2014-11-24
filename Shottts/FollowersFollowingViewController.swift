//
//  FollowersFollowingViewController.swift
//  Shottts
//
//  Created by Anatoliy Adamitskiy on 11/7/14.
//  Copyright (c) 2014 Anatoliy Adamitskiy. All rights reserved.
//

import Foundation
import UIKit

var Title:String = "";
var category:String = "";
var url:String = "";

class FollowersFollowingViewController: UIViewController, UITableViewDelegate {
    
    var followFollowingCell:UINib = UINib(nibName: "FollowersFollowingTableViewCell", bundle: nil);
    var loadedFollowers:[String:UIImage] = [String:UIImage]();
    var loadedFollowing:[String:UIImage] = [String:UIImage]();
    var followersAvatarURLs:[String] = [];
    var followingAvatarURLs:[String] = [];
    var Usernames:[String] = [];
    
    
    // MARK: ------------
    // MARK: Outlets
    // MARK: ------------
    
    @IBOutlet weak var followFollowingTableView: UITableView!
    
    // MARK: ------------
    // MARK: ViewDidLoad
    // MARK: ------------
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        loadFollowersFollowing(category, URL: url);
        
        followFollowingTableView.registerNib(followFollowingCell, forCellReuseIdentifier: "cell");
    }
    
    
    func clear() {
        loadedFollowers = [String:UIImage]();
        loadedFollowing = [String:UIImage]();
        followersAvatarURLs = [];
        followingAvatarURLs = [];
        Usernames = [];
    }
    
    
    func loadFollowersFollowing(category:String, URL:String) {
        
        clear();
        
        var followersFollowingURL:NSURL = NSURL(string: "\(URL)?access_token=e7b2183f84ce00d570340c486be45c8c2a795ed95a2cc3191209356eebfbd370")!;
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(followersFollowingURL) { [unowned self] (data, response, error) in
            let json = JSON(data: data);
            
            if json.count == 0 {
                
            } else {
                self.followFollowingTableView.hidden = false;
            
                for var i = 0; i < json.count; i++ {
                    
                    if category == "Followers" {
                        
                        if let avatar = json[i]["follower"]["avatar_url"].string {
                            self.followersAvatarURLs.append(avatar);
                        }
                        
                        if let name = json[i]["follower"]["name"].string {
                            self.Usernames.append(name);
                        }
                        
                    } else if category == "Following" {
                        
                        if let avatar = json[i]["followee"]["avatar_url"].string {
                            self.followingAvatarURLs.append(avatar);
                        }
                        
                        if let name = json[i]["followee"]["name"].string {
                            self.Usernames.append(name);
                        }
                        
                    }
                }
            }
            
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), { () -> Void in
                
                if category == "Followers" {
                    
                    for avatar in self.followersAvatarURLs {
                        self.loadedFollowers[avatar] = UIImage(data: NSData(contentsOfURL: NSURL(string: avatar)!)!);
                    }
                    
                } else if category == "Following" {
                    
                    for avatar in self.followingAvatarURLs {
                        self.loadedFollowing[avatar] = UIImage(data: NSData(contentsOfURL: NSURL(string: avatar)!)!);
                    }
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.followFollowingTableView.reloadData();
                })
            })
        }
        
        task.resume();
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        self.title = Title;
    }
    
    // MARK: ------------
    // MARK: Followers/Following Table View
    // MARK: ------------
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Usernames.count;
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: FollowersFollowingTableViewCell = followFollowingTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as FollowersFollowingTableViewCell;
        
        if self.title == "Followers" {
            
            cell.usersName.text = Usernames[indexPath.row];
            if let followers = loadedFollowers[followersAvatarURLs[indexPath.row]] {
                cell.userAvatar.image = followers;
            }
            
        } else {
            
            cell.usersName.text = Usernames[indexPath.row];
            if let following = loadedFollowing[followingAvatarURLs[indexPath.row]] {
                cell.userAvatar.image = following;
            }
            
        }
        followFollowingTableView.tableFooterView = UIView(frame: CGRectZero);
        return cell;
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0;
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    // MARK: ------------
    // MARK: Actions
    // MARK: ------------
    
    
    @IBAction func goHome(sender: UIButton) {
        
        self.navigationController?.popToRootViewControllerAnimated(true);
        
    }
    
}