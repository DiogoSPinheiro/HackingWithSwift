//
//  ViewController.swift
//  Challenge19-21
//
//  Created by Diogo Santiago Pinheiro on 09/03/22.
//

import UIKit

class ViewController: UITableViewController {

	var notes = [StoredNotes]()
	var emptyView = EmptyView()
	
	required init?(coder aDecoder: NSCoder) {
	   super.init(coder: aDecoder)
//		notes.append(StoredNotes(text: "titulo", title: "texto"))
//		notes.append(StoredNotes(text: "titulo", title: "texto"))
//		notes.append(StoredNotes(text: "titulo", title: "texto"))
//		notes.append(StoredNotes(text: "titulo", title: "texto"))
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		emptyView.delegate = self
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		do {
			if let storedNotesEncoded = UserDefaults.standard.data(forKey: "storedNotes") {
				let storedNotes = try JSONDecoder().decode([StoredNotes].self, from: storedNotesEncoded)
				self.notes = storedNotes
				tableView.reloadData()
			}
		} catch {
			fatalError("Notes cant be loaded in list, it can't happen")
		}
	}

	func verifyEmptyList() {
		if notes.isEmpty {
			navigationItem.rightBarButtonItem = nil
			self.tableView.backgroundView = emptyView
			self.tableView.isScrollEnabled = false
			self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
		} else {
			navigationController?.navigationBar.tintColor = .systemOrange
			navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(createNewNoteSelector))
			self.tableView.isScrollEnabled = true
			self.tableView.backgroundView = nil
			self.emptyView.removeFromSuperview()
		}
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		verifyEmptyList()
		return notes.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "NotesCell", for: indexPath)
		return setupCell(with: cell, position: indexPath.row)
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		createNewNote(index: indexPath.row)
	}
	
	@objc func createNewNoteSelector() {
		createNewNote()
	}
	
	 func createNewNote(index: Int = -1) {
		if let detailView = storyboard?.instantiateViewController(withIdentifier: "NotesNavigationViewController") as? NotesNavigationViewController {
			if index != -1 {
				detailView.storedNote = notes[index]
			}
			navigationController?.pushViewController(detailView, animated: true)
		}
	}
	
	func setupCell(with cell: UITableViewCell, position: Int) -> UITableViewCell {
		if #available(iOS 14.0, *) {
			var insideCell = cell.defaultContentConfiguration()
			insideCell.text = notes[position].title
			insideCell.secondaryText = notes[position].subTitle
			cell.contentConfiguration = insideCell
			
		} else {
			cell.textLabel?.text = notes[position].title
			cell.detailTextLabel?.text = notes[position].subTitle
		}
		
		return cell
	}
}

extension ViewController: EmptyViewDelegate {
	func createNode() {
		self.createNewNote()
	}
}
