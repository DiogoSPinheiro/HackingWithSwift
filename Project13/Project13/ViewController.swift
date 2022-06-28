//
//  ViewController.swift
//  Project13
//
//  Created by Diogo Santiago Pinheiro on 04/03/22.
//

import UIKit
import CoreImage

class ViewController: UIViewController {

	@IBOutlet var imageView: UIImageView!
	@IBOutlet var intensity: UISlider!
	@IBOutlet var changeButton: UIButton!
	
	var currentImage: UIImage!
	var context: CIContext!
	var currentFilter: CIFilter!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "InstaFilter"
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
		context = CIContext()
		currentFilter = CIFilter(name: "CISepiaTone")
	}
	
	@objc func importPicture() {
		let picker = UIImagePickerController()
		picker.allowsEditing = true
		picker.delegate = self
		present(picker, animated: true)
	}


	@IBAction func changeFilter(_ sender: UIButton) {
		let ac = UIAlertController(title: "Choose Filter", message: nil, preferredStyle: .actionSheet)
		
		ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
		ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
		ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
		ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
		ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
		ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
		ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		
		if let popOverController = ac.popoverPresentationController {
			popOverController.sourceView = sender
			popOverController.sourceRect = sender.bounds
		}
		
		present(ac, animated: true)
	}

	@IBAction func save(_ sender: Any) {
		if let image = imageView.image {
			UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
		} else {
			let ac = UIAlertController(title: "Empty image", message: "Please choose one image", preferredStyle: .alert)
			ac.addAction(UIAlertAction(title: "OK", style: .default))
			present(ac, animated: true)
		}
	}
	
	@IBAction func intensityChange(_ sender: Any) {
		applyProcessing()
	}
	
	func setFilter(action: UIAlertAction) {
	
		guard let actionTitle = action.title else { return }
		
		currentFilter = CIFilter(name: actionTitle)
		
		let beginImage = CIImage(image: currentImage)
		currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
		
		changeButton.setTitle(actionTitle, for: .normal)
		
		applyProcessing()
	}
	
	
	func applyProcessing() {
		
		let inputKeys = currentFilter.inputKeys
		
		if inputKeys.contains(kCIInputIntensityKey) {
			currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
		}
		
		if inputKeys.contains(kCIInputRadiusKey) {
			currentFilter.setValue(intensity.value * 200, forKey: kCIInputRadiusKey)
		}
		
		if inputKeys.contains(kCIInputScaleKey) {
			currentFilter.setValue(intensity.value * 10, forKey: kCIInputScaleKey)
		}
		
		if inputKeys.contains(kCIInputCenterKey) {
			currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey)
		}
		
		if let outputimage = currentFilter.outputImage,
			let cgImage = context.createCGImage(outputimage, from: outputimage.extent) {
			let processImage = UIImage(cgImage: cgImage)
			imageView.image = processImage
		}
	}
	
	@objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
		if let error = error {
			let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
			ac.addAction(UIAlertAction(title: "Ok", style: .default))
		} else {
			let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos", preferredStyle: .alert)
			ac.addAction(UIAlertAction(title: "Ok", style: .default))
			present(ac, animated: true)
		}
	}
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let image = info[.editedImage] as? UIImage else { return }
		dismiss(animated: true)
		currentImage = image
		
		let beginImage = CIImage(image: image)
		currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
		applyProcessing()
	}
}

