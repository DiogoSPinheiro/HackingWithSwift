//
//  AppDelegate.swift
//  Challenge19-21
//
//  Created by Diogo Santiago Pinheiro on 09/03/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	
	var window: UIWindow?
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		self.window = UIWindow(frame: UIScreen.main.bounds)
		
		window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
//		let apois = UIViewController()
//		apois.view.backgroundColor = .blue
//		window?.rootViewController = apois
		window?.makeKeyAndVisible()
		
		return true
	}
}

