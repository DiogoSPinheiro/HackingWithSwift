//
//  DetailsViewController.swift
//  Challenge1-3
//
//  Created by Diogo Santiago Pinheiro on 21/02/22.
//

import UIKit

class DetailsViewController: UIViewController {
	
	@IBOutlet var imageView: UIImageView!
	var imageTitle: String?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = imageTitle
		if let imageTitle = imageTitle {
			self.imageView.image = UIImage(named: imageTitle)
		}
		imageView.layer.borderWidth = 1
		imageView.layer.borderColor = UIColor.black.cgColor
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareFlag))
		
	}
	
	@objc func shareFlag() {
		guard let image = imageView.image else {
			print("image error")
			return
		}
		let activity = UIActivityViewController(activityItems: [image], applicationActivities: [])
		activity.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
		present(activity, animated: true)
	}
}
