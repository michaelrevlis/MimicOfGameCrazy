//
//  CrazyViewController.swift
//  MimicOfGameCrazyApp
//
//  Created by MichaelRevlis on 2016/11/30.
//  Copyright © 2016年 MichaelRevlis. All rights reserved.
//

import UIKit
import WebKit

class CrazyViewController: UIViewController, WKNavigationDelegate {
    
    var WebView = WKWebView()
    var myActivityIndicator = UIActivityIndicatorView()
    let urlString = "https://www.youtube.com/watch?v="
    var videoId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fullScreenSize = UIScreen.main.bounds.size
        
        WebView.frame = CGRect(x: 0.0, y: 0.0, width: fullScreenSize.width, height: fullScreenSize.height)
        
        WebView.navigationDelegate = self
        
        self.view.addSubview(WebView)
        
        myActivityIndicator.activityIndicatorViewStyle = .gray
        myActivityIndicator.center = CGPoint(x: fullScreenSize.width / 2, y: fullScreenSize.height / 2)
        
        self.view.addSubview(myActivityIndicator)
        
        let fullUrlString = urlString + videoId
        guard let url = URL(string: fullUrlString) else {fatalError()}
        let urlRequest = URLRequest(url: url)
        WebView.load(urlRequest)
    }
    
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        myActivityIndicator.startAnimating()
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
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
