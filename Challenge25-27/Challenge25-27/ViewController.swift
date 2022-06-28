//
//  ViewController.swift
//  Challenge25-27
//
//  Created by Diogo Santiago Pinheiro on 06/03/22.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet var imageView: UIImageView!
	
	var topMessage: String!
	var bottomMessage: String!
	var image: UIImage!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
//		let alert = UIAlertController(title: "Upload Image", message: "Upload your image", preferredStyle: .alert)
//		alert.addAction(UIAlertAction(title: "Ok", style: .default){ [weak self] _ in
//			self?.uploadImage()
//		})
//		present(alert, animated: true)
		
		self.uploadImage()
	}
	
	func uploadImage() {
		let imagePicker = UIImagePickerController()
		imagePicker.allowsEditing = true
		imagePicker.delegate = self
		present(imagePicker, animated: true)
	}
	
	
	func drawFinalImage() {
		let renderer = UIGraphicsImageRenderer(size: CGSize(width: 1024, height: 1024))
		let image = renderer.image { ctx in

			let style = NSMutableParagraphStyle()
			style.alignment = .center

			let attrs: [NSAttributedString.Key: Any] = [
				.font: UIFont.systemFont(ofSize: 96),
				.paragraphStyle: style,
				.foregroundColor: UIColor.white
			]

			let attributedStringTop = NSAttributedString(string: topMessage, attributes: attrs)
			let attributedStringBottom = NSAttributedString(string: bottomMessage, attributes: attrs)

			let storedImage = self.image
			let rect = CGRect(x: 0, y: 162, width: 1024, height: 700)
			storedImage?.draw(in: rect)
			ctx.cgContext.addRect(rect)
			attributedStringTop.draw(with: CGRect(x: 0, y: 20, width: 1024, height: 512), options: .usesLineFragmentOrigin, context: nil)
			attributedStringBottom.draw(with: CGRect(x: 0, y: 850, width: 1024, height: 512), options: .usesLineFragmentOrigin, context: nil)

//
		}
		self.imageView.image = image
	}
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let image = info[.editedImage] as? UIImage else { return }
		self.image = image
		
		dismiss(animated: true, completion: {
			let alert = UIAlertController(title: "Top Message", message: "Type the meme message", preferredStyle: .alert)
			alert.addTextField()
			alert.addAction(UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
				if let text = alert.textFields?[0].text {
					self?.topMessage = text
				} else {
					self?.topMessage = ""
				}
				let alert = UIAlertController(title: "Bottom Message", message: "Type the meme message", preferredStyle: .alert)
				alert.addTextField()
				alert.addAction(UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
					if let text = alert.textFields?[0].text {
						self?.bottomMessage = text
					} else {
						self?.bottomMessage = ""
					}
					self?.drawFinalImage()
				})
				self?.present(alert, animated: true)
			})
			self.present(alert, animated: true)
		})
	}
}

