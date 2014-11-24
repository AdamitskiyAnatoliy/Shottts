//
//  SettingsViewController.swift
//  Shottts
//
//  Created by Anatoliy Adamitskiy on 11/7/14.
//  Copyright (c) 2014 Anatoliy Adamitskiy. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate {
    
    let themes:[String] = ["Light", "Dark", "Dribbble Orange", "Dribbble Pink"];
    let vc:ViewController = ViewController();
    
    @IBOutlet weak var themeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.title = "Settings";
        
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0;
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4;
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        themeTableView.tableFooterView = UIView(frame: CGRectZero);
        
        var cell: AnyObject = themeTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel.text = themes[indexPath.row];
        
        return cell as UITableViewCell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.row {
            
        case 0:
            self.navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 0.714, blue: 0.89, alpha: 1);
            vc.theme = "Blue";
        case 1:
            self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1);
            vc.theme = "Black";
        case 2:
            self.navigationController?.navigationBar.barTintColor = UIColor(red: 1, green: 0.533, blue: 0.2, alpha: 1);
            vc.theme = "Orange";
        case 3:
            self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.918, green: 0.298, blue: 0.537, alpha: 1);
            vc.theme = "Pink";
        default:
            return;
        }
        
        var saveLog:NSUserDefaults = NSUserDefaults.standardUserDefaults();
        
        var savedColor:String = vc.theme;
        
        saveLog.setObject(savedColor, forKey: "savedColor");
        
        saveLog.synchronize();
        
    }
    
    
    @IBAction func openTwitter(sender: UIButton) {
        
        webURL = "https://www.twitter.com/Shottts_iOS";
        
    }
    
    
    @IBAction func openFacebook(sender: UIButton) {
        
        webURL = "https://www.facebook.com/shottts";
        
    }
    
    
}