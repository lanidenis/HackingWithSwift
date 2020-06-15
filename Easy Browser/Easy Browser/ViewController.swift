//
//  ViewController.swift
//  Easy Browser
//
//  Created by Jelani Denis on 6/5/20.
//  Copyright © 2020 Jelani Denis. All rights reserved.
//

import UIKit
import WebKit

//class className: inheritSuper, implementProtocol
class ViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var progressView: UIProgressView!
    var websites = ["apple.com","hackingwithswift.com","google.com"]
    
    override func loadView(){
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load initial url
        let url = URL(string: "https://www.google.com")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
        //add open webpage button to NavBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        //add UIProgressBar to UIToolBar
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        //add other buttons to UIToolBar
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let back = UIBarButtonItem(barButtonSystemItem: .rewind, target: webView, action: #selector(webView.goBack))
        let forward = UIBarButtonItem(barButtonSystemItem: .fastForward, target: webView, action: #selector(webView.goForward))
        toolbarItems = [progressButton, spacer, back, forward, refresh] //[UIBarButtonItem]
        navigationController?.isToolbarHidden = false
        
        //use KVO to listen to changes on webView.estimatedProgress property
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
        
    @objc func openTapped() {
        //handle "open webpage" functionality
        let ac = UIAlertController(title: "Open page…", message: nil, preferredStyle: .actionSheet)
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem //only used in iPad to anchor alert popover to rightBarButtonItem
        present(ac, animated: true)
    }
    
    @objc func openPage(action: UIAlertAction) {
        let url = URL(string: "https://www." + action.title!)!
        webView.load(URLRequest(url:url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host {
            print(host)
            for website in websites {
                print("checking if host contains \(website)")
                if host.contains(website) {
                    print("allowing nav")
                    decisionHandler(.allow)
                    return
                }
            }
        }
        decisionHandler(.cancel)
        //show host denied alert box
        let ac = UIAlertController(title: "Host Denied", message: "The url you are trying to access has been blocked", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Close", style: .cancel, handler: { (UIAlertAction) in
            //doNothing
        }) )
        present(ac, animated: true)
    }
    
    


}

