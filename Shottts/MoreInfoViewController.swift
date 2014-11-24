//
//  MoreInfoViewController.swift
//  Shottts
//
//  Created by Anatoliy Adamitskiy on 11/5/14.
//  Copyright (c) 2014 Anatoliy Adamitskiy. All rights reserved.
//

import Foundation
import UIKit

var moreInfoImage:UIImage!
var shotTitle:String = "";
var commentUrl:String = "";
var commentAvatarURLs:[String] = [];
var commentUsernames:[String] = [];
var comments:[String] = [];

class MoreInfoViewController: UIViewController, UITableViewDelegate {
    
    var commentCell:UINib = UINib(nibName: "CommentsTableViewCell", bundle: nil);
    var head:UINib = UINib(nibName: "MoreInfoTableViewHeader", bundle: nil);
    var headImage:UINib = UINib(nibName: "MoreInfoTableViewImage", bundle: nil);
    var loadedCommentAvatars:[String:UIImage] = [String:UIImage]();
    var nsURL:NSURL = NSURL(string: "\(commentUrl)?access_token=e7b2183f84ce00d570340c486be45c8c2a795ed95a2cc3191209356eebfbd370&per_page=100")!;
    
    // MARK: ------------
    // MARK: Outlets
    // MARK: ------------
    
    @IBOutlet weak var commentTableView: UITableView!
    
    // MARK: ------------
    // MARK: ViewDidLoad
    // MARK: ------------
    
    override func viewDidLoad() {
        
        refreshComments();
        
        super.viewDidLoad()
        
        self.title = shotTitle;
        
        commentTableView.registerNib(commentCell, forCellReuseIdentifier: "cell");
        commentTableView.registerNib(head, forHeaderFooterViewReuseIdentifier: "header");
        commentTableView.registerNib(headImage, forHeaderFooterViewReuseIdentifier: "header2");
    }
    
   

    
    func refreshComments() {
        
        commentAvatarURLs = [];
        commentUsernames = [];
        comments = [];
        loadedCommentAvatars = [String:UIImage]();
        


        let task = NSURLSession.sharedSession().dataTaskWithURL(nsURL) { [weak self] (data, response, error) in
            let json = JSON(data: data);
            
            if let strongSelf = self {
                
                
                for var i = 0; i < json.count; i++ {
                    
                    if let avatar = json[i]["user"]["avatar_url"].string {
                        commentAvatarURLs.append(avatar);
                    }
                    
                    if let name = json[i]["user"]["name"].string {
                        commentUsernames.append(name);
                    }
                    
                    if let comment = json[i]["body"].string {
                        
                        let reg:NSRegularExpression  = NSRegularExpression(
                            pattern: "<.*?>",
                            options: NSRegularExpressionOptions.CaseInsensitive,
                            error: nil)!;
                        let range = NSMakeRange(0, countElements(comment));
                        let htmlLessString :String = reg.stringByReplacingMatchesInString(comment,
                            options: NSMatchingOptions.allZeros,
                            range:range ,
                            withTemplate: "");
                        
                        comments.append(htmlLessString);
                    }
                }
            }
            
            
            
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), { () -> Void in
                
                if let strongSelf = self {
                    for avatar in commentAvatarURLs {
                        strongSelf.loadedCommentAvatars[avatar] = UIImage(data: NSData(contentsOfURL: NSURL(string: avatar)!)!);
                    }
                    
                    
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        strongSelf.commentTableView.reloadData();
                    })
                    
                }
                else {
                    println("Crash Would have happened!");
                }
            })
        }
        
        task.resume();
    }

    
    
    // MARK: ------------
    // MARK: Comments Table View
    // MARK: ------------
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var returnNum:Int = commentAvatarURLs.count;
        
        if section == 0 {
            returnNum = 0;
        }
        
        return returnNum;
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: CommentsTableViewCell = commentTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as CommentsTableViewCell;
        
        if let commentAvatar = loadedCommentAvatars[commentAvatarURLs[indexPath.row]] {
            cell.userAvatar.image = commentAvatar;
        } else {
            cell.userAvatar.image = UIImage(named: "dribbbleLogo.png");
        }
        
        cell.player.text = commentUsernames[indexPath.row];
        cell.comment.text = comments[indexPath.row];
        
        return cell;
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.0;
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        var returnNum:CGFloat = 150.0;
        
        if section == 0 {
            
            let screenSize: CGRect = UIScreen.mainScreen().bounds
            
            switch screenSize.height {
            case 480:
                returnNum = 241.0;
            case 568:
                returnNum = 241.0;
            case 667:
                returnNum = 282.0;
            default:
                returnNum = 311.0;
            }
        }
        
        return returnNum;
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2;
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var header:UIView!
        
        if section == 0 {
            
            header = commentTableView.dequeueReusableHeaderFooterViewWithIdentifier("header2") as MoreInfoTableViewImage;
            
        } else if section == 1 {
            
            header = commentTableView.dequeueReusableHeaderFooterViewWithIdentifier("header") as MoreInfoTableViewHeader;
            
        }
        
        return header;
    }
    
}