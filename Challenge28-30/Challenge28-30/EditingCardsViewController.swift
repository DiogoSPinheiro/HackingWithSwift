//
//  EditingCardsViewController.swift
//  Challenge28-30
//
//  Created by Diogo Santiago Pinheiro on 12/03/22.
//

import UIKit

class EditingCardsViewController: UITableViewController {
	var cards: [CardCell]!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItem))
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		cards = UserDefaultsManager.singleton.retrieve()
		tableView.reloadData()
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return cards.count / 2
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CardTableCell", for: indexPath)
		
		cell.textLabel?.text = "Color \(cards[indexPath.row * 2].identifier), pair: \( cards[(indexPath.row * 2) + 1].identifier)"
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let alert = UIAlertController(title: "Remove", message: "Dou you want to remove this color ?", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Yes", style: .destructive) { _ in
			
			UserDefaultsManager.singleton.removeCell(cardName: self.cards[indexPath.row * 2].identifier)
			UserDefaultsManager.singleton.removeCell(cardName: self.cards[(indexPath.row * 2) + 1].identifier)
			
			self.cards = UserDefaultsManager.singleton.retrieve()
			tableView.reloadData()
		})
		alert.addAction(UIAlertAction(title: "No", style: .default))
		present(alert, animated: true)
	}

	@objc func addNewItem() {
		if let createCardViewController = storyboard?.instantiateViewController(withIdentifier: "CreateCardViewController") {
			navigationController?.pushViewController(createCardViewController, animated: true)
		}
	}
}
