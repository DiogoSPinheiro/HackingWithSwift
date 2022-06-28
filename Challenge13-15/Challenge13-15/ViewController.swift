//
//  ViewController.swift
//  Challenge13-15
//
//  Created by Diogo Santiago Pinheiro on 05/03/22.
//

import UIKit

class ViewController: UITableViewController {

	var countries = [Country]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "List of Countries"
		loadCountries()
	}
	
	func loadCountries() {
		if let countries = Bundle.main.url(forResource: "countries", withExtension: "txt"),
		   let data = try? Data(contentsOf: countries) {
			
			let jsonDecoder = JSONDecoder()
			var countriesAsData = Countries()
			do {
				countriesAsData = try jsonDecoder.decode(Countries.self, from: data)
			} catch {
				print("Error in json")
			}
			self.countries = countriesAsData.countries
			tableView.reloadData()
		}
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return countries.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
		cell.textLabel?.text = countries[indexPath.row].name
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let vc = storyboard?.instantiateViewController(withIdentifier: "CountryTableInformation") as? CountryTableInformation {
			vc.country = countries[indexPath.row]
			vc.title = countries[indexPath.row].name
			navigationController?.pushViewController(vc, animated: true)
		}
	}
}

