//
//  TermAndConditionsViewController.swift
//  LogsCheck
//
//  Created by Akash Deep Kaushik on 07/05/18.
//  Copyright © 2018 Akash Deep Kaushik. All rights reserved.
//

import UIKit

class TermAndConditionsViewController: UIViewController,UIWebViewDelegate {

    @IBOutlet weak var actIndicator: UIActivityIndicatorView!
    @IBOutlet weak var WebVW: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        WebVW.loadRequest(URLRequest(url: URL(string:"https://alldaytime.co.uk/about/terms/")!));
        WebVW.delegate = self
        actIndicator.startAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        actIndicator.stopAnimating()
    }
    

}
