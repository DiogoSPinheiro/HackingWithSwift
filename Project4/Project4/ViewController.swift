//
//  ViewController.swift
//  Project4
//
//  Created by Diogo Santiago Pinheiro on 21/02/22.
//

import UIKit
import WebKit

class ViewController: UIViewController {

	var webView: WKWebView!
	var progressView: UIProgressView!
	let websites = ["apple.com", "google.com"]
	
	override func loadView() {
		webView = WKWebView()
		webView.navigationDelegate = self
		view = webView
		let url = URL(string: "https://\(websites[0])")!
		webView.load(URLRequest(url: url))
		webView.allowsBackForwardNavigationGestures = true
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
		
		let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		
		let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reload))
		
		progressView = UIProgressView(progressViewStyle: .default)
		progressView.sizeToFit()
		let progressButton = UIBarButtonItem(customView: progressView)
		
		let nextTollButton = UIBarButtonItem(barButtonSystemItem: .fastForward, target: self, action: #selector(forward))
		let fowardTollButton = UIBarButtonItem(barButtonSystemItem: .undo, target: self, action: #selector(previous))
		
		toolbarItems = [progressButton, nextTollButton, fowardTollButton, spacer, refresh]
		navigationController?.isToolbarHidden = false
		
		webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
	}
	
	@objc func reload() {
		webView.reload()
	}
	
	@objc func forward() {
		webView.goForward()
	}
	
	@objc func previous() {
		webView.goBack()
	}
	
	@objc func openTapped() {
		let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
		for site in websites {
			ac.addAction(UIAlertAction(title: site, style: .default, handler: openPage))
		}
		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
		present(ac, animated: true)
	}
	
	func openPage(action: UIAlertAction) {
		guard let actionTitle = action.title,
		let url = URL(string: "https://" + actionTitle) else {
			print("error in URL")
			return
		}
		
		webView.load(URLRequest(url: url))
		webView.allowsBackForwardNavigationGestures = true
	}
}

extension ViewController: WKNavigationDelegate {
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		title = webView.title
	}
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		progressView.progress = Float(webView.estimatedProgress)
	}
	
	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		let url = navigationAction.request.url
		if let host = url?.host {
			for sites in websites {
				if host.contains(sites) && !host.contains("google") {
					decisionHandler(.allow)
					return
				}
			}
			let alert = UIAlertController(title: "Site not allowed", message: "Dont google it, found it", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Ok", style: .default))
			present(alert, animated: true)
		}
		decisionHandler(.cancel)
	}
}

