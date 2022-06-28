//
//  ViewController.swift
//  Project18
//
//  Created by Diogo Santiago Pinheiro on 05/03/22.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		
		print(1,2,3,4, separator: "-", terminator: "\n\n")
		
		assert(1 == 1, "Fails")
		
		let error = UIStoryboard.init(name: "M", bundle: nil)
	}
}

