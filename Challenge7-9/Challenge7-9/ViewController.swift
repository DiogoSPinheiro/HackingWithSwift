//
//  ViewController.swift
//  Challenge7-9
//
//  Created by Diogo Santiago Pinheiro on 24/02/22.
//

import UIKit

class ViewController: UIViewController {

	var lifeCounter: UILabel!
	var word: UILabel!
	var answer: UITextField!
	var button: UIButton!
	var usedLetters: UILabel!
	
//	let attributedPlays = NSMutableAttributedString(string:)
	
	var plays: Int = 10
	var words = [String]()
	var correctWord = ""
	
	override func loadView() {
		setupLabels()
		loadBundler()
		loadGame()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
	
	func loadBundler() {
		guard let bundle = Bundle.main.url(forResource: "start", withExtension: "txt"),
			  let bundleContent = try? String(contentsOf: bundle) else { return }
		self.words = bundleContent.components(separatedBy: "\n")
		self.words.removeLast()
	}

	func setupLabels() {
		self.view = UIView()
		view.backgroundColor = .white
		
		lifeCounter = UILabel()
		lifeCounter.translatesAutoresizingMaskIntoConstraints = false
		lifeCounter.attributedText = setupAttributed()
			
		view.addSubview(lifeCounter)
		
		word = UILabel()
		word.translatesAutoresizingMaskIntoConstraints = false
		word.text = ""
		word.font = UIFont.systemFont(ofSize: 30)
		view.addSubview(word)
		
		answer = UITextField()
		answer.translatesAutoresizingMaskIntoConstraints = false
		answer.textAlignment = .center
		answer.tintColor = .white
		answer.textColor = .white
		answer.attributedPlaceholder = NSAttributedString(
			string: "Digite sua letra",
			attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
		)
		answer.backgroundColor = .lightGray
		answer.addTarget(self, action: #selector(verifyLetter), for: .editingChanged)
		view.addSubview(answer)
		
		usedLetters = UILabel()
		usedLetters.translatesAutoresizingMaskIntoConstraints = false
		usedLetters.text = "Letras usadas: []"
		view.addSubview(usedLetters)
		
		button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setTitle("Confirmar letra", for: .normal)
		button.backgroundColor = .blue
		button.layer.cornerRadius = 10
		button.addTarget(self, action: #selector(confirmLetter), for: .touchUpInside)
		button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .bold)
		view.addSubview(button)
		
		
		NSLayoutConstraint.activate([
			lifeCounter.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			lifeCounter.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
			word.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			word.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
			answer.topAnchor.constraint(equalTo: word.bottomAnchor, constant: 160),
			answer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			answer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8, constant: -20),
			answer.heightAnchor.constraint(equalToConstant: 40),
			usedLetters.topAnchor.constraint(equalTo: answer.bottomAnchor, constant: 20),
			usedLetters.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant:  -60),
			button.heightAnchor.constraint(equalToConstant: 60),
			button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
		])
	}
	
	func setupAttributed() -> NSMutableAttributedString {
		let playsText = NSMutableAttributedString(string: "Vidas: ")
		let playsString = NSMutableAttributedString(string: "\(self.plays)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.red])
		playsText.append(playsString)
		return playsText
	}
	
	@objc func confirmLetter(sender: UIButton) {
		guard let answerText = self.answer.text,
		!answerText.isEmpty else { return }
		
		let oldWord = word.text
		word.text?.removeAll()
		answer.text?.removeAll()
		plays -= 1
		
		for letter in correctWord {
			let stringLetter = String(letter)
			
			if stringLetter.contains(answerText) || oldWord?.firstIndex(of: letter) != nil {
				word.text? += stringLetter
			} else {
				word.text? += "?"
			}
		}
	
		if !usedLetters.text!.contains(answerText) {
			usedLetters.text?.removeLast()
			usedLetters.text?.append(", ")
			usedLetters.text = usedLetters.text?.replacingOccurrences(of: "[, ", with: "[")
			usedLetters.text?.append("\(answerText)]")
		}
		
		lifeCounter.attributedText = setupAttributed()
		
		if !word.text!.contains("?") {
			endGame(true)
		} else if plays == 0 {
			endGame(false)
		}
	}

	@objc func verifyLetter(_ textField: UITextField) {
		guard let answerText = self.answer.text else { return }
		if answerText.count > 1 {
			textField.text?.removeLast()
		}
	}
	
	func loadGame() {
		
		plays = 10
		
		let randomWord = Int.random(in: 0..<words.count)
		
		answer.text?.removeAll()
		word.text?.removeAll()
		correctWord = words[randomWord].uppercased()
		usedLetters.text = "Letras usadas: []"
		lifeCounter.attributedText = setupAttributed()
		
		for _ in 0..<correctWord.count {
			word.text? += "?"
		}
		
		print(correctWord)
	}
	
	func endGame(_ state: Bool) {
		
		let title: String
		let message: String
		
		if state {
			title = "Win"
			message = "You win =), play again"
		} else {
			title = "Lose"
			message = "Ow you lose =/. Try again =)"
		}
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Ok", style: .default) { [weak self] alert in
			self?.loadGame()
		})
		present(alert, animated: true)
	}
}

