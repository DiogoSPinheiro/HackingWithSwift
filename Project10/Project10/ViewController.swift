//
//  ViewController.swift
//  Project10
//
//  Created by Diogo Santiago Pinheiro on 03/03/22.
//

import UIKit

class ViewController: UICollectionViewController {
	
	var people = [Person]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
		
		let defaults = UserDefaults.standard
		
		if let savedPeople = defaults.object(forKey: "savedPeople") as? Data {
			do {
				people = JSONDecoder().decode([Person].self, from: savedPeople)
			} catch {
				print("Error in decode")
			}
		}
		
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return people.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
			fatalError("Unable to dequeue PersonCell.")
		}
		let person = people[indexPath.item]
		let path = getDocumentsDirectory().appendingPathComponent(person.image)
		cell.name.text = person.name
		cell.imageView.image = UIImage(contentsOfFile: path.path)
		cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
		cell.imageView.layer.borderWidth = 2
		cell.imageView.layer.cornerRadius = 3
		cell.layer.cornerRadius = 7
		
		return cell
	}
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let person = people[indexPath.item]
		let ac = UIAlertController(title: "Action", message: "Do you want to write a text or delete?", preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
			self?.people.remove(at: indexPath.section)
			self?.save()
			self?.collectionView.reloadData()
		})
		
		ac.addAction(UIAlertAction(title: "Rename", style: .default) { [weak self] _ in
			self?.showTextDialog(person: person)
		})
		present(ac, animated: true)
	}
	
	func showTextDialog(person: Person) {
		let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
		ac.addTextField()
		ac.addAction(UIAlertAction(title: "Ok", style: .default) { [weak self, weak ac] _ in
			guard let newName = ac?.textFields?[0].text else { return }
			person.name = newName
			self?.save()
			self?.collectionView.reloadData()
		})
		
		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		present(ac, animated: true)
	}
	
	@objc func addNewPerson() {
		let picker = UIImagePickerController()
		picker.allowsEditing = true
		picker.delegate = self
		present(picker, animated: true)
	}
	
	func save() {
		let jsonEncoder = JSONEncoder()
		if let savedPeople = jsonEncoder.encode(people) as? Data {
			let defaults = UserDefaults.standard
			defaults.set(savedPeople, forKey: "savedPeople")
		} else {
			print("Error in encode")
		}
	}
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let image = info[.editedImage] as? UIImage else { return }
		
		let imageName = UUID().uuidString
		let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
		if let jpegData = image.jpegData(compressionQuality: 0.8) {
			try? jpegData.write(to: imagePath)
		}
		
		let person = Person(name: "Unknown", image: imageName)
		people.append(person)
		save()
		collectionView.reloadData()
		
		dismiss(animated: true)
	}
	
	func getDocumentsDirectory() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return paths[0]
	}
}

