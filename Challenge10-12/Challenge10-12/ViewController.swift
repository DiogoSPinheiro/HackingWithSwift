//
//  ViewController.swift
//  Challenge10-12
//
//  Created by Diogo Santiago Pinheiro on 03/03/22.
//

import UIKit

class ViewController: UITableViewController {

	var pickerImage: UIImagePickerController!
	var name: String = ""
	var images = [Image]()
	var userDefaults = UserDefaults.standard
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupImagePicker()
		getImagesFromUserDefaults()
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPhoto))
		
		//defaults images
	}
	
	func setupImagePicker() {
		pickerImage = UIImagePickerController()
		pickerImage.allowsEditing = true
		pickerImage.delegate = self
		pickerImage.sourceType = .camera
	}
	
	@objc func addNewPhoto() {
		let ac = UIAlertController(title: "Name", message: "Insert the image name", preferredStyle: .alert)
		ac.addTextField()
		ac.addAction(UIAlertAction(title: "Ok", style: .default) { [weak self, weak ac] _ in
			if let text = ac?.textFields?[0].text,
			   let picker = self?.pickerImage,
			   !text.isEmpty {
				self?.name = text
				self?.present(picker, animated: true)
			}
		})
		present(ac,animated: true)
	}
	
	func saveInUserDefaults() {
		let jsonEncoder = JSONEncoder()
		if let encodedImages = try? jsonEncoder.encode(images) {
			userDefaults.set(encodedImages, forKey: "images")
		}
	}
	
	func getImagesFromUserDefaults() {
		let jsonDecoder = JSONDecoder()
		if let imagesEnconded = userDefaults.object(forKey: "images") as? Data {
			do {
				let images = try jsonDecoder.decode([Image].self, from: imagesEnconded)
				self.images = images
			} catch {
				print("Error in images retrived from user defaults")
			}
		}
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return images.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Image", for: indexPath)
		cell.textLabel?.text = images[indexPath.row].name
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let vc = storyboard?.instantiateViewController(withIdentifier: "ImageViewController") as? ImageViewController {
			let path = getDocumentDirectory().appendingPathComponent(images[indexPath.row].image)
			vc.title = images[indexPath.row].name
			vc.imageString = path.path
			navigationController?.pushViewController(vc, animated: true)
		}
	}
}


extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let image = info[.editedImage] as? UIImage else { return }
		
		let imageName = UUID().uuidString
		let imagePath = getDocumentDirectory().appendingPathComponent(imageName)
		if let jpegData = image.jpegData(compressionQuality: 0.8) {
			try? jpegData.write(to: imagePath)
		}
		
		self.images.append(Image(name: name, image: imageName))
		self.tableView.reloadData()
		saveInUserDefaults()
		dismiss(animated: true)
	}
	
	func getDocumentDirectory() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return paths[0]
	}
}
