//
//  LogInViewController.swift
//  Shottts
//
//  Created by Anatoliy Adamitskiy on 11/7/14.
//  Copyright (c) 2014 Anatoliy Adamitskiy. All rights reserved.
//

import Foundation
import UIKit

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    var myProfilePage:MyProfileViewController = MyProfileViewController();
    var isLogInGood = true;
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "Log In";
    }
    
    
    @IBAction func logIn(sender: UIButton) {
        
        for Character in usernameField.text {
            if Character == " " {
                let alert = UIAlertController(title: "Invalid Log In", message: "Please Try Again", preferredStyle: UIAlertControllerStyle.Alert);
                let okay = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil);
                alert.addAction(okay);
                self.presentViewController(alert, animated: true, completion: nil);
                
                return;
            }
        }
        
        if isLogInGood == false {
            return;
        } else {
            
            username = usernameField.text;
            
            isUserLoggedIn = true;
            
            var saveLog:NSUserDefaults = NSUserDefaults.standardUserDefaults();
            
            var savedUser:String = username;
            var loggedIn:Bool = isUserLoggedIn;
            
            saveLog.setObject(savedUser, forKey: "savedUser");
            saveLog.setObject(loggedIn, forKey: "loggedIn");
            
            saveLog.synchronize();
            
            self.navigationController?.popViewControllerAnimated(true);
            
            let myProfile = self.storyboard?.instantiateViewControllerWithIdentifier("MyProfileViewController") as MyProfileViewController;
            self.navigationController?.pushViewController(myProfile, animated: true);
            
        }
    }
    
    
    func checkURL(use:String) {
        
        var userUrl:NSURL = NSURL(string: "https://api.dribbble.com/v1/users/\(use)?access_token=e7b2183f84ce00d570340c486be45c8c2a795ed95a2cc3191209356eebfbd370")!;
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(userUrl) { [unowned self] (data, response, error) in
            let json = JSON(data: data);
            
            println(json);
            
            if json[0]["message"].string == "Not found." {
                self.isLogInGood = false;
                return;
            } else {
                return;
            }
            
        }
        
        task.resume();
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        switch textField.tag {
            
        case 0:
            passwordField.becomeFirstResponder();
        case 1:
            passwordField.resignFirstResponder();
        default:
            return false;
        }
        
        return true;
    }
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true);
    }
    
}