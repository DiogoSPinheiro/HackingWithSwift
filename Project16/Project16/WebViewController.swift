//
//  WebViewController.swift
//  Project16
//
//  Created by Diogo Santiago Pinheiro on 05/03/22.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
		
	var webView: WKWebView!
	var url: String?
	
	override func loadView() {
		super.loadView()
		
		webView = WKWebView()
		webView.navigationDelegate = self
		view = webView
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if let urlString = url,
		   let url = URL(string: urlString) {
			let urlRequest = URLRequest(url: url)
			webView.load(urlRequest)
		}
	}
}
