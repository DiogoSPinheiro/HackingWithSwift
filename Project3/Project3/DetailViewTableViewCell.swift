//
//  DetailViewTableViewCell.swift
//  Project1
//
//  Created by Diogo Santiago Pinheiro on 21/02/22.
//

import UIKit

class DetailViewController: UIViewController {

	
	@IBOutlet var ImageView: UIImageView!
	var selectedImage: String?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.largeTitleDisplayMode = .never
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(sharedTapped))
		
		if let selectedImage = selectedImage {
			ImageView.image = UIImage(named: selectedImage)
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.hidesBarsOnTap = true
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.hidesBarsOnTap = false
	}
	
	@objc func sharedTapped() {
		
		guard let image = ImageView.image?.jpegData(compressionQuality: 0.8) else {
			print("No image found")
			return
		}
		
		let vc = UIActivityViewController(activityItems: [image, selectedImage!], applicationActivities: [])
		
		// para o ipad entender o que está acontecendo
		
		vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
		present(vc, animated: true)
	}
	
}
