//
//  ViewController.swift
//  Project7
//
//  Created by Diogo Santiago Pinheiro on 23/02/22.
//

import UIKit

class ViewController: UITableViewController {

	var petitions = [Petition]() { didSet {
		filteredPetitions = petitions
	}}
	
	var filteredPetitions = [Petition]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let urlString: String
		
		if navigationController?.tabBarItem.tag == 0 {
			urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
		} else {
			urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
		}
		let leftButton = CustomBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showURL(sender: )))
		leftButton.url = urlString
		
		navigationItem.leftBarButtonItem = leftButton
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(filterPetitions))
		
		performSelector(inBackground: #selector(fetchJSON), with: nil)
	}
	
	@objc func fetchJSON() {
		
		let urlString: String
		
		if navigationController?.tabBarItem.tag == 0 {
			urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
		} else {
			urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
		}
		
		if let url = URL(string: urlString) {
			if let data = try? Data(contentsOf: url) {
				parse(json: data)
				return
			}
		}
		performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
	}
	
	@objc func filterPetitions() {
		let alert = UIAlertController(title: "Filter", message: "Filter in titles and subtitles", preferredStyle: .alert)
		alert.addTextField()
		
		alert.addAction(UIAlertAction(title: "Clear", style: .default) { _  in
			self.filteredPetitions = self.petitions
			self.tableView.reloadData()
		})
		
		alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
			if let text = alert.textFields?[0].text {
				self.filteredPetitions.removeAll()
				for cell in self.petitions {
					if cell.title.contains(text) || cell.body.contains(text) {
						self.filteredPetitions.append(cell)
					}
				}
				self.tableView.reloadData()
			}
		})
		
		
		present(alert, animated: true)
	}
	
	@objc func showURL(sender: Any) {
		var message = ""
		if let button = sender as? CustomBarButtonItem {
			message = button.url
		}
		
		let ac = UIAlertController(title: "Data from", message: "This date come from: \(message)", preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "OK", style: .default))
		present(ac, animated: true)
	}
	
	func parse(json: Data) {
		let decoder = JSONDecoder()
		
		if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
			petitions = jsonPetitions.results
			tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
		} else {
			performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
		}
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return filteredPetitions.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		cell.textLabel?.text = filteredPetitions[indexPath.row].title
		cell.detailTextLabel?.text =  filteredPetitions[indexPath.row].body
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let vc = DetailViewController()
		vc.detailItem = filteredPetitions[indexPath.row]
		navigationController?.pushViewController(vc, animated: true)
	}
	
	@objc func showError() {
		let ac = UIAlertController(title: "Loading error", message: "Error in request", preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "OK", style: .default))
		 present(ac, animated: true)
	}
}

class CustomBarButtonItem: UIBarButtonItem {
	var url: String = ""
}
