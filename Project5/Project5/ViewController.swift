//
//  ViewController.swift
//  Project5
//
//  Created by Diogo Santiago Pinheiro on 22/02/22.
//

import UIKit

class ViewController: UITableViewController {
	
	var allWords = [String]()
	var useWords = [String]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
		
		if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"),
		   let startWords = try? String(contentsOf: startWordsURL) {
			allWords = startWords.components(separatedBy: "\n")
		}
		
		if allWords.isEmpty {
			allWords = ["none"]
		}
		
		startGame()
	}
	
	@objc func startGame() {
		title = allWords.randomElement()
		useWords.removeAll(keepingCapacity: true)
		tableView.reloadData()
	}
	
	@objc func promptForAnswer() {
		let ac = UIAlertController(title: "Enter message", message: nil, preferredStyle: .alert)
		ac.addTextField()
		
		let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
			guard let answer = ac?.textFields?[0].text else { return }
			self?.submit(answer)
		}
		
		ac.addAction(submitAction)
		present(ac, animated: true)
	}
	
	func submit(_ answer: String) {
		
		let lowerAnswer = answer.lowercased()
		if isShorter(lowerAnswer) {
			if isPossible(lowerAnswer) {
				if isOriginal(lowerAnswer) {
					if isReal(lowerAnswer) {
						useWords.insert(answer, at: 0)
						let indexPath = IndexPath(row: 0, section: 0)
						tableView.insertRows(at: [indexPath], with: .automatic)
					} else {
						showErrorAlert(title: "Word not recognized", message: "You can't just make them up, you know!")
					}
				} else {
					showErrorAlert(title: "Word already use", message: "Be more original!")
				}
			} else {
				showErrorAlert(title: "Word not possible", message: "You can't spell that word from \(title!.lowercased())")
			}
		} else {
			showErrorAlert(title: "Word is too small", message: "This is shorter than 3 characters")
		}
	}
	
	func isShorter(_ word: String) -> Bool {
		return word.count >= 3
	}
	
	func isPossible(_ word: String) -> Bool {
		guard var tempWord = title?.lowercased() else { return false}
		
		for letter in word {
			if let position = tempWord.firstIndex(of: letter) {
				tempWord.remove(at: position)
			} else {
				return false
			}
		}
		return true
	}
	
	func showErrorAlert(title: String, message: String) {
		let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "OK", style: .default))
		present(ac, animated: true)
	}
	
	func isOriginal(_ word: String) -> Bool {
		return !useWords.contains(word) && word != title
	}
	
	func isReal(_ word: String) -> Bool {
		let checker = UITextChecker()
		let range = NSRange(location: 0, length: word.utf16.count)
		let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
		return misspelledRange.location == NSNotFound
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return useWords.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
		cell.textLabel?.text = useWords[indexPath.row]
		return cell
	}
}

