//
//  NotesNavigationViewController.swift
//  Challenge19-21
//
//  Created by Diogo Santiago Pinheiro on 09/03/22.
//

import UIKit

class NotesNavigationViewController: UIViewController {
	
	@IBOutlet var notesText: UITextView!
	var storedNote: StoredNotes!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.navigationBar.tintColor = .systemOrange
		navigationItem.rightBarButtonItems = [
			UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removeSelf)),
			UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(sendText))
		]
		
		if let storedNote = storedNote {
			self.notesText.text = storedNote.text
		}
		
		self.notesText.delegate = self
		changeText(textView: self.notesText)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		
		super.viewWillDisappear(animated)
		
		guard let text = notesText.text else {  return  }
		
		var storedNotes = [StoredNotes]()
		
		if storedNote == nil {
			
			guard !text.isEmpty else { return }
			
			if let data = UserDefaults.standard.data(forKey: "storedNotes") {
				do {
					let decodeCurrentStoredNotes = try JSONDecoder().decode([StoredNotes].self, from: data)
					storedNotes.append(contentsOf: decodeCurrentStoredNotes)
					
				} catch {
					fatalError("Note cant be read, it can't happen")
				}
			}
			
			if let firstLine = text.components(separatedBy: "\n").first {
				if text.components(separatedBy: "\n").count > 1 {
					storedNote = StoredNotes(text: text, title: firstLine, subTitle: text.components(separatedBy: "\n")[1], index: storedNotes.count == 0 ? 0 : storedNotes.count - 1)
				} else {
					storedNote = StoredNotes(text: text, title: firstLine, subTitle: "Sem texto adicional", index: storedNotes.count == 0 ? 0 : storedNotes.count - 1)
				}
			}
			
			if !storedNotes.isEmpty {
				storedNotes.append(storedNote)
			} else {
				storedNotes = [storedNote]
			}
			
			do{
				let encodedNote = try JSONEncoder().encode(storedNotes)
				UserDefaults.standard.set(encodedNote, forKey: "storedNotes")
			} catch {
				fatalError("Note cant be stored in list, it can't happen")
				
			}
			
		} else {
			storedNote.title = text.components(separatedBy: "\n").first ?? ""
			storedNote.text = notesText.text
			
			if text.components(separatedBy: "\n").count > 1 {
				storedNote.subTitle = text.components(separatedBy: "\n")[1]
			} else {
				storedNote.subTitle  = "Sem texto adicional"
			}
			
			if let data = UserDefaults.standard.data(forKey: "storedNotes") {
				do {
					var decodeCurrentStoredNotes = try JSONDecoder().decode([StoredNotes].self, from: data)
					if text.isEmpty {
						decodeCurrentStoredNotes.remove(at: storedNote.index)
					} else {
						decodeCurrentStoredNotes[storedNote.index] = storedNote
					}
					let encodedNote = try JSONEncoder().encode(decodeCurrentStoredNotes)
					UserDefaults.standard.set(encodedNote, forKey: "storedNotes")
				} catch {
					fatalError("Note cant be stored in list, it can't happen")
				}
			}
		}
	}
	
	@objc func sendText() {
		if let notesText = notesText.text,
		   !notesText.isEmpty {
			let alertController = UIActivityViewController(activityItems: [notesText], applicationActivities: nil)
			present(alertController, animated: true)
		}
	}
	
	@objc func removeSelf() {
		if let storedNote = storedNote,
		   let data = UserDefaults.standard.data(forKey: "storedNotes") {
			do {
				var decodeCurrentStoredNotes = try JSONDecoder().decode([StoredNotes].self, from: data)
				if let index = decodeCurrentStoredNotes.firstIndex(where: {$0.index == storedNote.index}) {
					decodeCurrentStoredNotes.remove(at: index)
					
					let encodedNote = try JSONEncoder().encode(decodeCurrentStoredNotes)
					UserDefaults.standard.set(encodedNote, forKey: "storedNotes")
					self.storedNote = nil
					self.notesText.text = ""
					navigationController?.popViewController(animated: true)
				}
				
			} catch {
				fatalError("Notes must exist, it can't happen")
			}
		} else {
			self.notesText.text = ""
			navigationController?.popViewController(animated: true)
		}
	}
	
	func changeText(textView: UITextView) {
		let attributeSmallSize: [NSAttributedString.Key: Any] = [
			.font: UIFont.systemFont(ofSize: 16),
			.foregroundColor: UIColor.white
				
		]
		let attributeBigSize: [NSAttributedString.Key: Any] = [
			.font: UIFont.systemFont(ofSize: 30),
			.foregroundColor: UIColor.white
			
		]
		
		if textView.text.last != "\n" {
			return
		}
		
		
		let combination = NSMutableAttributedString()
		
			for lines in 0...textView.text.components(separatedBy: "\n").count - 1 {
				guard !textView.text.components(separatedBy: "\n")[lines].isEmpty else { continue }
				if lines == 0 {
					combination.append(NSAttributedString(string: "\(textView.text.components(separatedBy: "\n")[lines])\n", attributes: attributeBigSize))
				} else {
					combination.append(NSAttributedString(string: "\(textView.text.components(separatedBy: "\n")[lines])\n", attributes: attributeSmallSize))
				}
			}
		
			notesText.attributedText = combination
	}
	
}

extension NotesNavigationViewController: UITextViewDelegate {
	
	func textViewDidChange(_ textView: UITextView) {
		changeText(textView: textView)
	}
}
