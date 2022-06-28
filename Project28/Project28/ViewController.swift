//
//  ViewController.swift
//  Project28
//
//  Created by Diogo Santiago Pinheiro on 07/03/22.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

	@IBOutlet var secret: UITextView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let notificationCenter = NotificationCenter.default
		notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
		notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

		notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: #selector(saveSecretMessage))
		navigationItem.rightBarButtonItem?.customView?.isHidden = true
		title = "Nothing to see here"
		
		KeychainWrapper.standard.set("SenhaMockada1234", forKey: "password")
	}
	
	@IBAction func authenticateTapped(_ sender: UIButton) {
		let context = LAContext()
		var error: NSError?
		
		if !context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
			let reason = "Identify yourself!"
			
			context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
				DispatchQueue.main.async {
					if success {
						self?.unlockSecretMessage()
					} else {
						self?.showPasswordError()
					}
				}
			}
		} else {
			let alert = UIAlertController(title: "Biometry not available", message: "Your device is not configured for biometric authentication, insert the password", preferredStyle: .alert)
			alert.addTextField()
			alert.addAction(UIAlertAction(title: "Ok", style: .default) { [weak self, weak alert] _ in
				if let text = alert?.textFields?.first?.text,
				   let password = KeychainWrapper.standard.string(forKey: "password"),
				   text == password{
					self?.unlockSecretMessage()
				} else {
					self?.showPasswordError()
				}
			})
			present(alert, animated: true)
		}
	}
	
	func showPasswordError() {
		let alert = UIAlertController(title: "Authenticate failed", message: "You could not be verified; please try again", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Ok", style: .default))
		self.present(alert, animated: true)
	}
	
	@objc func adjustForKeyboard(notification: Notification) {
		guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
		
		let keyboardScreenEnd = keyboardValue.cgRectValue
		let keyboardViewEndFrame = view.convert(keyboardScreenEnd, to: view.window)
		
		if notification.name == UIResponder.keyboardWillHideNotification {
			secret.contentInset = .zero
		} else {
			secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
		}
		
		secret.scrollIndicatorInsets = secret.contentInset

		let selectedRange = secret.selectedRange
		secret.scrollRangeToVisible(selectedRange)
	}
	
	func unlockSecretMessage() {
		navigationItem.rightBarButtonItem?.title = "Done"
		secret.isHidden = false
		title = "Secret Message"
		
		secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
	}
	
	@objc func saveSecretMessage() {
		guard secret.isHidden == false else { return }
		navigationItem.rightBarButtonItem?.title = ""

		KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
		secret.resignFirstResponder()
		secret.isHidden = true
		title = "Nothing to see here"
	}
}

