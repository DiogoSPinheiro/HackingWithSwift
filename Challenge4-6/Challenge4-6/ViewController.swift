//
//  ViewController.swift
//  Challenge4-6
//
//  Created by Diogo Santiago Pinheiro on 23/02/22.
//

import UIKit

class ViewController: UITableViewController {
	
	var itemsList = [String]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setNavigation()
	}
	
	func setNavigation() {
		title = "Shop items list"
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removeList))
		navigationItem.rightBarButtonItems = [
			UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAlert)),
			UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(sendList))
		]
	}
	
	@objc func removeList() {
		let alert = UIAlertController(title: "Remove list", message: "Do yoy really want clear shop list?", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
		alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
			self?.itemsList.removeAll()
			self?.tableView.reloadData()
		})
		present(alert, animated: true)
	}
	
	@objc func showAlert() {
		let alert = UIAlertController(title: "Insert shop item", message: nil, preferredStyle: .alert)
		alert.addTextField()
		alert.addAction(UIAlertAction(title: "Send", style: .default) { [weak self] _ in
			if let text = alert.textFields?[0].text {
				self?.addItem(text)
			}
		})
		present(alert, animated: true)
	}
	
	@objc func sendList() {
		let oneItem = itemsList.joined(separator: "\n")
		let activityController = UIActivityViewController(activityItems: [oneItem], applicationActivities: [])
		activityController.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem
		
		present(activityController, animated: true)
	}
	
	func addItem(_ item: String) {
		itemsList.insert(item, at: 0)
		let indexPath = IndexPath(row: 0, section: 0)
		tableView.insertRows(at: [indexPath], with: .automatic)
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return itemsList.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
		cell.textLabel?.text = itemsList[indexPath.row]
		return cell
	}
}

