//
//  BmwinViewController.swift
//  PlanDemo
//
//  Created by 王洋洋 on 2017/3/16.
//  Copyright © 2017年 wyy. All rights reserved.
//

import UIKit

class BmwinViewController: UIViewController {

    var webV: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "bmwinビーエムウィン"
        self.view.backgroundColor = UIColor.white
        
        initWebView()

    }
    
    func initWebView() {
        
        webV = UIWebView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        
        let url = URL(string: "https://www.google.com")
        let request = URLRequest(url: url!)
        webV.loadRequest(request)
        
        webV.scalesPageToFit = true
        
        webV.delegate = self
        
        view.addSubview(webV)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}

extension BmwinViewController: UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("start load")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("finish load")
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("fail load")
    }
    
}
