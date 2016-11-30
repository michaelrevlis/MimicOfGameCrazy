//
//  AdViewController.swift
//  MimicOfGameCrazyApp
//
//  Created by MichaelRevlis on 2016/12/1.
//  Copyright © 2016年 MichaelRevlis. All rights reserved.
//

import UIKit
import WebKit

class AdViewController: UIViewController, WKNavigationDelegate {
    
    var WebView = WKWebView()
    var myActivityIndicator = UIActivityIndicatorView()
    var urlString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fullScreenSize = UIScreen.mainScreen().bounds.size
        
        WebView.frame = CGRect(x: 0.0, y: 0.0, width: fullScreenSize.width, height: fullScreenSize.height)
        
        WebView.navigationDelegate = self
        
        self.view.addSubview(WebView)
        
        myActivityIndicator.activityIndicatorViewStyle = .Gray
        myActivityIndicator.center = CGPoint(x: fullScreenSize.width / 2, y: fullScreenSize.height / 2)
        
        self.view.addSubview(myActivityIndicator)
        
        guard let url = NSURL(string: urlString) else {fatalError()}
        let urlRequest = NSURLRequest(URL: url)
        WebView.loadRequest(urlRequest)
    }
    
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        myActivityIndicator.startAnimating()
    }
    
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        myActivityIndicator.stopAnimating()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
