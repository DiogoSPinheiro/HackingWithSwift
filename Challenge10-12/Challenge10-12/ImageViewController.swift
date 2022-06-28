//
//  ImageViewController.swift
//  Challenge10-12
//
//  Created by Diogo Santiago Pinheiro on 03/03/22.
//

import Foundation
import UIKit

class ImageViewController: UIViewController {
	
	@IBOutlet var imageView: UIImageView!
	var imageString: String?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		if let imageString = imageString {
			imageView.image = UIImage(contentsOfFile: imageString)
		}
	}
}
