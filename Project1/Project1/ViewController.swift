//
//  ViewController.swift
//  Project1
//
//  Created by Diogo Santiago Pinheiro on 21/02/22.
//

import UIKit

class ViewController: UITableViewController {

	var pictures = [String]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let fm = FileManager.default
		let path = Bundle.main.resourcePath!
		let items = try! fm.contentsOfDirectory(atPath: path)
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareApp))
		
		title = "Storm View"
		navigationController?.navigationBar.prefersLargeTitles = true
		
		for item in items {
			if item.hasPrefix("nssl") {
				pictures.append(item)
			}
		}
		
		pictures.sort()
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return pictures.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
		cell.textLabel?.text = pictures[indexPath.row]
		return cell	
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
			vc.selectedImage = pictures[indexPath.row]
			vc.title = "Picture \(indexPath.row + 1) of \(pictures.count)"
			navigationController?.pushViewController(vc, animated: true)
		}
	}
	
	 @objc func shareApp() {
		 let secondActivityItem : NSURL = NSURL(string: "https://apps.apple.com/br/app/google-chrome/id535886823")!
		 let vc = UIActivityViewController(activityItems: [secondActivityItem], applicationActivities: [])
		 vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
		 present(vc, animated: true)
	}
}

