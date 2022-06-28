//
//  ViewController.swift
//  Project2
//
//  Created by Diogo Santiago Pinheiro on 21/02/22.
//

import UIKit

class ViewController: UIViewController {

	
	@IBOutlet var firstFlag: UIButton!
	@IBOutlet var secondFlag: UIButton!
	@IBOutlet var thirdFlag: UIButton!
	
	var countries = [String]()
	var score = 0
	var correctAnswer = 0
	var answers = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
		
		firstFlag.layer.borderWidth = 1
		secondFlag.layer.borderWidth = 1
		thirdFlag.layer.borderWidth = 1
		
		view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
		navigationController?.navigationBar.backgroundColor = .white
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showScore))
		
		firstFlag.layer.borderColor = UIColor.lightGray.cgColor
		secondFlag.layer.borderColor = UIColor.lightGray.cgColor
		thirdFlag.layer.borderColor = UIColor.lightGray.cgColor
		askQuestion()
	}
	
	func askQuestion(action: UIAlertAction! = nil) {
		countries.shuffle()
		answers += 1
		correctAnswer = Int.random(in: 0...2)
		firstFlag.setImage(UIImage(named: countries[0]), for: .normal)
		secondFlag.setImage(UIImage(named: countries[1]), for: .normal)
		thirdFlag.setImage(UIImage(named: countries[2]), for: .normal)
		
		title = "\(countries[correctAnswer].uppercased()) \(answers > 10 ? 10 : answers) / 10"
	}
	
	@objc func showScore() {
		let ac = UIAlertController(title: "Score", message: "\(score)", preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
		ac.addAction(UIAlertAction(title: "OK GRRR", style: .destructive, handler: nil))
		present(ac, animated: true)
	}

	
	@IBAction func buttonTapped(_ sender: UIButton) {
		var title: String
		var message = "Your score is \(score)"
		
		if sender.tag == correctAnswer {
			score += 1
			message = "Your score is \(score)"
			title = "Correct"
			askQuestion()
		} else {
			title = "Wrong"
			message = "Correct answer is flag number \(correctAnswer + 1)"
			score -= 1
		}
		
		if answers == 11 || title.contains("Wrong") {
			score = answers == 11 ? 0 : score
			answers = answers == 11 ? 0 : answers
			let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
			ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
			present(ac, animated: true)
		}
	}
}

