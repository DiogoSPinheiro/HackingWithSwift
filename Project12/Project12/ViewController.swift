//
//  ViewController.swift
//  Project12
//
//  Created by Diogo Santiago Pinheiro on 03/03/22.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		let defaults = UserDefaults.standard
		
		defaults.set(25, forKey: "Age")
		defaults.set(true, forKey: "UseCamera")
		defaults.set(CGFloat.pi, forKey: "Pi")
		
		defaults.set("Test", forKey: "Test")
		defaults.set(Date(), forKey: "stored date")
		
		let array = ["a", "b"]
		let dict = ["a": "b"]
		
		defaults.set(array, forKey: "array")
		defaults.set(dict, forKey: "dict")
		
		let integer = defaults.integer(forKey: "Age")
		let boolean = defaults.bool(forKey: "UseCamera")
		
		let defaultArray = defaults.object(forKey: "array") as? [String] ?? [String]()
	}
}

