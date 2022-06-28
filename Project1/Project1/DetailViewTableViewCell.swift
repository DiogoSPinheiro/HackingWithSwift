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
}
