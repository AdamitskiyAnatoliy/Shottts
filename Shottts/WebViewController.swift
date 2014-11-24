//
//  WebViewController.swift
//  Shottts
//
//  Created by Anatoliy Adamitskiy on 11/13/14.
//  Copyright (c) 2014 Anatoliy Adamitskiy. All rights reserved.
//

import Foundation
import UIKit

var webURL:String = "";

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    var openURL:NSURL = NSURL(string: webURL)!;
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        var request:NSURLRequest = NSURLRequest(URL: openURL);
        webView.loadRequest(request);
    }
    
    @IBAction func closeWebView(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil);
        
    }
    
}