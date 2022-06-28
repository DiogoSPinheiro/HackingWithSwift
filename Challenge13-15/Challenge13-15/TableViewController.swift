//
//  TableViewController.swift
//  Challenge13-15
//
//  Created by Diogo Santiago Pinheiro on 05/03/22.
//

import UIKit

class CountryTableInformation: UITableViewController {
	
	var country: Country?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showFact))
    }
	
	@objc func showFact() {
		let alert = UIAlertController(title: "Fact", message: country?.fact, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Get it", style: .default))
		present(alert, animated: true)
	}

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "information", for: indexPath)
		
		switch indexPath.row {
		case 0:
			cell.textLabel?.text = "Code: \(country!.code)"
			break
		case 1:
			cell.textLabel?.text = "Capital: \(country!.capital)"
			break
		case 2:
			cell.textLabel?.text = "Currency: \(country!.currency)"
			break
		default:
			break
		}
		return cell
		
	}
	
}
