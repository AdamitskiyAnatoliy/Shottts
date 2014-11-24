//
//  ViewController.swift
//  Shottts
//
//  Created by Anatoliy Adamitskiy on 11/3/14.
//  Copyright (c) 2014 Anatoliy Adamitskiy. All rights reserved.
//

import UIKit

import SystemConfiguration

public class Reachability {
    
    func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0)).takeRetainedValue()
        }
        
        var flags: SCNetworkReachabilityFlags = 0
        if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == 0 {
            return false
        }
        
        let isReachable = (flags & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return (isReachable && !needsConnection) ? true : false
    }
    
}

var isUserLoggedIn:Bool = false;
var mainTitle:String = "Popular";
var shotURLs:[String] = [];
var avatarURLs:[String] = [];
var webViewURLs:[String] = [];
var pageNum:Int = 1;

class ViewController: UIViewController, UITableViewDelegate, SideBarDelegate {
    
    var url = NSURL(string: "https://api.dribbble.com/v1/shots?access_token=e7b2183f84ce00d570340c486be45c8c2a795ed95a2cc3191209356eebfbd370&page=\(String(pageNum))");
    var theme:String = "Blue";
    var scrollingToTop = false;
    var mainTableViewCellNib = UINib(nibName: "MainShotsTableViewCell", bundle: nil);
    var sideBar:SideBar = SideBar();
    var navOpen:Bool = false;
    var loadedImages:[String:UIImage] = [String:UIImage]();
    var loadedAvatars:[String:UIImage] = [String:UIImage]();
    var refresher:UIRefreshControl = UIRefreshControl();
    var rowHeight:CGFloat!;
    var shotTitles:[String] = [];
    var usersName:[String] = [];
    var shotDescription:[String] = [];
    var comments:[Int] = [];
    var likes:[Int] = [];
    var views:[Int] = [];
    var commentURLs:[String] = [];
    
    // MARK: ------------
    // MARK: Outlets
    // MARK: ------------
    
    @IBOutlet weak var mainShotsTableView: UITableView!;
    @IBOutlet weak var selectedCategoryLabel: UINavigationItem!;
    
    // MARK: ------------
    // MARK: ViewDidLoad
    // MARK: ------------
    
    override func viewDidLoad() {
        
        if Reachability().isConnectedToNetwork() == false {
            mainShotsTableView.hidden = true;
        }
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent;
        
        var saveLog:NSUserDefaults = NSUserDefaults.standardUserDefaults();
        
        if let set: AnyObject = saveLog.objectForKey("savedUser") {
            var savedUser:String = saveLog.objectForKey("savedUser") as String;
            var loggedIn:Bool = saveLog.objectForKey("loggedIn") as Bool;
        
            username = savedUser;
            isUserLoggedIn = loggedIn;
        }
        
        if let setCol: AnyObject = saveLog.objectForKey("savedColor") {
            var color:String = saveLog.objectForKey("savedColor") as String;
            theme = color;
        }
        
        super.viewDidLoad()
        
        if theme == "Blue" {
            self.navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 0.714, blue: 0.89, alpha: 1);
        } else if theme == "Black" {
            self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1);
        } else if theme == "Orange" {
            self.navigationController?.navigationBar.barTintColor = UIColor(red: 1, green: 0.533, blue: 0.2, alpha: 1);
        } else if theme == "Pink" {
            self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.918, green: 0.298, blue: 0.537, alpha: 1);
        }
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        switch screenSize.height {
        case 480:
            rowHeight = 241.0;
        case 568:
            rowHeight = 241.0;
        case 667:
            rowHeight = 282.0;
        default:
            rowHeight = 311.0;
        }
        
        self.title = mainTitle;
        
        mainShotsTableView.registerNib(mainTableViewCellNib, forCellReuseIdentifier: "cell");
        
        sideBar = SideBar(sourceView: self.view, menuItems: ["Popular", "Debuts", "Playoffs", "Rebounds", "Settings"]);
        sideBar.delegate = self;
        
        refreshMainShots(0)
       
        refresher.addTarget(self, action: "refresherMain", forControlEvents: UIControlEvents.ValueChanged);
        self.mainShotsTableView.addSubview(refresher);
        
    }
    
    func refresherMain() {
        refreshMainShots(0);
    }
    
    func clear() {
        shotURLs = [];
        avatarURLs = [];
        shotTitles = [];
        usersName = [];
        shotDescription = [];
        comments = [];
        likes = [];
        views = [];
        commentURLs = [];
        webViewURLs = [];
        loadedImages = [String:UIImage]();
        loadedAvatars = [String:UIImage]();
    }
    
    func refreshMainShots(num:Int) {
        
        if num == 0 {
            pageNum = 1;
            clear();
            
            if self.title == "Popular" {
                url = NSURL(string: "https://api.dribbble.com/v1/shots?access_token=e7b2183f84ce00d570340c486be45c8c2a795ed95a2cc3191209356eebfbd370&page=\(String(pageNum))");
            } else if self.title == "Debuts" {
                url = NSURL(string: "https://api.dribbble.com/v1/shots?access_token=e7b2183f84ce00d570340c486be45c8c2a795ed95a2cc3191209356eebfbd370&page=\(String(pageNum))&list=debuts");
            } else if self.title == "Playoffs" {
                url = NSURL(string: "https://api.dribbble.com/v1/shots?access_token=e7b2183f84ce00d570340c486be45c8c2a795ed95a2cc3191209356eebfbd370&page=\(String(pageNum))&list=playoffs");
            } else if self.title == "Rebounds" {
                url = NSURL(string: "https://api.dribbble.com/v1/shots?access_token=e7b2183f84ce00d570340c486be45c8c2a795ed95a2cc3191209356eebfbd370&page=\(String(pageNum))&list=rebounds");
            }

            
        } else if num == 1 {
            pageNum++;
            
            if self.title == "Popular" {
                url = NSURL(string: "https://api.dribbble.com/v1/shots?access_token=e7b2183f84ce00d570340c486be45c8c2a795ed95a2cc3191209356eebfbd370&page=\(String(pageNum))");
            } else if self.title == "Debuts" {
                url = NSURL(string: "https://api.dribbble.com/v1/shots?access_token=e7b2183f84ce00d570340c486be45c8c2a795ed95a2cc3191209356eebfbd370&page=\(String(pageNum))&list=debuts");
            } else if self.title == "Playoffs" {
                url = NSURL(string: "https://api.dribbble.com/v1/shots?access_token=e7b2183f84ce00d570340c486be45c8c2a795ed95a2cc3191209356eebfbd370&page=\(String(pageNum))&list=playoffs");
            } else if self.title == "Rebounds" {
                url = NSURL(string: "https://api.dribbble.com/v1/shots?access_token=e7b2183f84ce00d570340c486be45c8c2a795ed95a2cc3191209356eebfbd370&page=\(String(pageNum))&list=rebounds");
            }
            
        }
        
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) { [unowned self] (data, response, error) in
            let json = JSON(data: data);
            
            for var i = 0; i < json.count; i++ {
                if let shot = json[i]["images"]["hidpi"].string {
                    shotURLs.append(shot);
                }
                
                if let shot2 = json[i]["images"]["hidpi"].null {
                    shotURLs.append(json[i]["images"]["normal"].string!);
                }
                
                if let avatar = json[i]["user"]["avatar_url"].string {
                    avatarURLs.append(avatar);
                }
                
                if let title = json[i]["title"].string {
                    self.shotTitles.append(title);
                }
                
                if let name = json[i]["user"]["name"].string {
                    self.usersName.append(name);
                }
                
                if let description = json[i]["description"].string {
                   
                    let reg:NSRegularExpression  = NSRegularExpression(
                        pattern: "<.*?>",
                        options: NSRegularExpressionOptions.CaseInsensitive,
                        error: nil)!;
                    let range = NSMakeRange(0, countElements(description));
                    let htmlLessString :String = reg.stringByReplacingMatchesInString(description,
                        options: NSMatchingOptions.allZeros,
                        range:range ,
                        withTemplate: "");
                    
                    self.shotDescription.append(htmlLessString);
                }
                
                if let description2 = json[i]["description"].null {
                    self.shotDescription.append(" No Description");
                }
                
                if let comment = json[i]["comments_count"].int {
                    self.comments.append(comment);
                }
                
                if let like = json[i]["likes_count"].int {
                    self.likes.append(like);
                }
                
                if let view = json[i]["views_count"].int {
                    self.views.append(view);
                }
                
                if let comURL = json[i]["comments_url"].string {
                    self.commentURLs.append(comURL);
                }
                
                if let shotURL = json[i]["html_url"].string {
                    webViewURLs.append(shotURL);
                }
            }
            
            self.refresher.endRefreshing()
            
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), { () -> Void in
                
                for avatar in avatarURLs {
                    self.loadedAvatars[avatar] = UIImage(data: NSData(contentsOfURL: NSURL(string: avatar)!)!);
                }
                
                for shot in shotURLs {
                    self.loadedImages[shot] = UIImage(data: NSData(contentsOfURL: NSURL(string: shot)!)!);
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.mainShotsTableView.reloadData();
                    })
                    
                }
                
            })
            if pageNum == 1 {
                self.mainShotsTableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true);
            }
            
        }
        
        task.resume()

    }
    
    
    // MARK: ------------
    // MARK: Side Navigation
    // MARK: ------------
    
    func sideBarDidSelectButtonAtIndex(index: Int) {
        
        switch index {
            
        case 0:
            self.scrollingToTop = true;
            self.title = "Popular";
            url = NSURL(string:"https://api.dribbble.com/v1/shots?access_token=e7b2183f84ce00d570340c486be45c8c2a795ed95a2cc3191209356eebfbd370");
            refreshMainShots(0);
            sideBar.showSideBar(false);
            sideBar.delegate?.sideBarWillClose?();
            navOpen = false;
        case 1:
            self.scrollingToTop = true;
            self.title = "Debuts";
            mainShotsTableView.scrollRectToVisible(CGRectZero, animated: true);
            url = NSURL(string:"https://api.dribbble.com/v1/shots?access_token=e7b2183f84ce00d570340c486be45c8c2a795ed95a2cc3191209356eebfbd370&list=debuts");
            refreshMainShots(0);
            sideBar.showSideBar(false);
            sideBar.delegate?.sideBarWillClose?();
            navOpen = false;
        case 2:
            self.scrollingToTop = true;
            self.title = "Playoffs";
            url = NSURL(string:"https://api.dribbble.com/v1/shots?access_token=e7b2183f84ce00d570340c486be45c8c2a795ed95a2cc3191209356eebfbd370&list=playoffs");
            refreshMainShots(0);
            sideBar.showSideBar(false);
            sideBar.delegate?.sideBarWillClose?();
            navOpen = false;
        case 3:
            self.scrollingToTop = true;
            self.title = "Rebounds";
            url = NSURL(string:"https://api.dribbble.com/v1/shots?access_token=e7b2183f84ce00d570340c486be45c8c2a795ed95a2cc3191209356eebfbd370&list=rebounds");
            refreshMainShots(0);
            sideBar.showSideBar(false);
            sideBar.delegate?.sideBarWillClose?();
            navOpen = false;
        case 4:
            let settings = self.storyboard?.instantiateViewControllerWithIdentifier("SettingsViewController") as SettingsViewController;
            self.navigationController?.pushViewController(settings, animated: true);
            sideBar.showSideBar(false);
            sideBar.delegate?.sideBarWillClose?();
            navOpen = false;
        default:
            break;
            
        }
        
    }
    
    
    // MARK: ------------
    // MARK: Start of Main Shots Table
    // MARK: ------------
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shotURLs.count;
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: MainShotsTableViewCell = mainShotsTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as MainShotsTableViewCell;
        
        if scrollingToTop == true {
            
        } else {
            
            if let image = loadedImages[shotURLs[indexPath.row]] {
                cell.mainShotImageView.image = image;
                cell.hasImage = true;
            } else {
                cell.mainShotImageView.image = UIImage(named: "dribbbleLogo.png");
                cell.hasImage = false;
            }
            
            if let avatar = loadedAvatars[avatarURLs[indexPath.row]] {
                cell.mainAvatarImageView.image = avatar;
            } else {
                cell.mainAvatarImageView.image = UIImage(named: "dribbbleLogo.png");
            }
            
            cell.contentView.sendSubviewToBack(cell.mainShotImageView);
            
        }
        
        return cell;
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return rowHeight;
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? MainShotsTableViewCell {
            if cell.hasImage == false {
                return;
            }
            
        }
        
        
        if let image = loadedImages[shotURLs[indexPath.row]] {
            moreInfoImage = image;
        }
        
        if let avatar = loadedAvatars[avatarURLs[indexPath.row]] {
            moreInfoMainAvatarImage = avatar;
        }
        
        shotTitle = shotTitles[indexPath.row];
        playerName = usersName[indexPath.row];
        descriptionString = shotDescription[indexPath.row];
        commentString = String(comments[indexPath.row]);
        likeString = String(likes[indexPath.row]);
        viewString = String(views[indexPath.row]);
        commentUrl = commentURLs[indexPath.row];
        webURL = webViewURLs[indexPath.row];
        
        let moreInfo = self.storyboard?.instantiateViewControllerWithIdentifier("MoreInfoViewController") as MoreInfoViewController;
        self.navigationController?.pushViewController(moreInfo, animated: true);
    }
    
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == shotURLs.count - 1 {
            refreshMainShots(1);
        }
        
        if indexPath.row == 0 {
            self.scrollingToTop = false;
        }
    }
    
    
    // MARK: ------------
    // MARK: Actions
    // MARK: ------------
    
    /* Action that opens up the Navigation Menu */
    @IBAction func navigationMenuButtonAction(sender: UIBarButtonItem) {
        
        if navOpen {
            
            sideBar.showSideBar(false)
            sideBar.delegate?.sideBarWillClose?();
            navOpen = false;
            
        } else {
            
            sideBar.showSideBar(true)
            sideBar.delegate?.sideBarWillOpen?();
            navOpen = true;
            
        }
        
    }
    
    @IBAction func myProfileButtonAction(sender: UIBarButtonItem) {

        if isUserLoggedIn {
            let myProfile = self.storyboard?.instantiateViewControllerWithIdentifier("MyProfileViewController") as MyProfileViewController;
            self.navigationController?.pushViewController(myProfile, animated: true);
        } else {
            let logIn = self.storyboard?.instantiateViewControllerWithIdentifier("LogInViewController") as LogInViewController;
            self.navigationController?.pushViewController(logIn, animated: true);
        }
        
    }
    
}

