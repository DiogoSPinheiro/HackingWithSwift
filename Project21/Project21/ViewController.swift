//
//  ViewController.swift
//  Project21
//
//  Created by Diogo Santiago Pinheiro on 09/03/22.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
	}
	
	@objc func registerLocal() {
		let center = UNUserNotificationCenter.current()
		
		center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
			if granted {
				print("granted")
			} else {
				print("error")
			}
		}
	}
	
	@objc func scheduleLocal() {
		
		registerCategories()
		
		let center = UNUserNotificationCenter.current()
		center.removeAllPendingNotificationRequests()
		
		let content = UNMutableNotificationContent()
		content.title = "Hello"
		content.body = "Local notification here"
		content.categoryIdentifier = "customID"
		content.userInfo = ["customData": "fizzbuzz"]
		content.sound = .default
		
		
		var dateComponents = DateComponents()
		dateComponents.hour = 10
		dateComponents.minute = 30
//		let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
		let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
		let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
		center.add(request)
	}
	
	func registerCategories() {
		let center = UNUserNotificationCenter.current()
		center.delegate = self
		
		let alert1 = UNNotificationAction(identifier: "alert1", title: "Show me alert 1", options: .foreground)
		let alert2 = UNNotificationAction(identifier: "alert2", title: "Show me alert 2", options: .foreground)
		let repeatAlarm = UNNotificationAction(identifier: "waitMore5Seconds" , title: "Remind me later", options: .foreground)
		let category = UNNotificationCategory(identifier: "customID", actions: [alert1, alert2, repeatAlarm], intentIdentifiers: [], options: [])
		center.setNotificationCategories([category])
		
	}
	
	func showAlert(title: String, message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Ok", style: .default))
		present(alert, animated: true)
	}
}

extension ViewController: UNUserNotificationCenterDelegate {
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		let userInfo = response.notification.request.content.userInfo
		
		if let customData = userInfo["customData"] as? String {
			print("Custom Data: \(customData)")
			
			switch response.actionIdentifier {
			case UNNotificationDefaultActionIdentifier:
				print("Default identifier")
			case "alert1":
				showAlert(title: "Alert 1", message: "Hey its me, alert 1")
			case "alert2":
				showAlert(title: "Alert 2", message: "2, I am 2")
			case "waitMore5Seconds":
				scheduleLocal()
				
			default: break
			}
		}
		completionHandler()
	}
}

