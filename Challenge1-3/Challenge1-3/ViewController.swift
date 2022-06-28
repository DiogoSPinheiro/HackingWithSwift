//
//  ViewController.swift
//  Challenge1-3
//
//  Created by Diogo Santiago Pinheiro on 21/02/22.
//

import UIKit

class ViewController: UITableViewController {

	let countries: [String] = ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Challenge"
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return countries.count
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Flags", for: indexPath)
		cell.textLabel?.text = countries[indexPath.row]
		cell.imageView?.image = UIImage(named: countries[indexPath.row])
		cell.imageView?.sizeToFit()
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController {
			vc.imageTitle = countries[indexPath.row]
			navigationController?.pushViewController(vc, animated: true)
			
		}
		
	}
}

