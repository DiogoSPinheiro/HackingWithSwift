//
//  ViewController.swift
//  Challenge28-30
//
//  Created by Diogo Santiago Pinheiro on 12/03/22.
//

import UIKit
import LocalAuthentication

class ViewController: UICollectionViewController {

	var cards: [CardCell]!
	
	var sections = 4
	var rows = 4
	var winStatus = 0
	
	var firstCard: CardCellCollectionViewCell!

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewCards))
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		cards = UserDefaultsManager.singleton.retrieve()
		self.winStatus = cards.count / 2
		sections = Int(sqrt(Double(cards.count)))
		rows = cards.count / sections + (cards.count % sections) / 2
		collectionView.reloadData()
	}

	@objc func addNewCards() {
		let context = LAContext()
		var error: NSError?
		
		if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
			let reason = "To add new elements you must have a permission"
			
			context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authError in
				DispatchQueue.main.async {
					if success {
						self?.navigateToAddLayout()
					} else {
						let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified; please try again.", preferredStyle: .alert)
						ac.addAction(UIAlertAction(title: "OK", style: .default))
						self?.present(ac, animated: true)
					}
				}
			}
		}  else {
			// if in xcode simulator, enroll in features
		}
	}
	
	func navigateToAddLayout() {
		if let cardCellEditingCardsViewController = storyboard?.instantiateViewController(withIdentifier: "EditingCardsViewController") as? EditingCardsViewController {
			navigationController?.pushViewController(cardCellEditingCardsViewController, animated: true)
		}
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return sections
	}
	
	override func numberOfSections(in collectionView: UICollectionView) -> Int {
		return rows
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as? CardCellCollectionViewCell {
			
			var card: CardCell
			
			if indexPath.section == cards.count / sections {
				if (sections * (cards.count / sections)) + indexPath.row >= cards.count {
					card = CardCell(index: 0, identifier: "", pair: "", colorBackground: nil, show: false)
					cell.card = card
					cell.notShow()
				} else {
					card = cards[(sections * (cards.count / sections)) + indexPath.row]
					cell.title.text = card.identifier
					cell.showBackCard()
				}
			} else {
				card = cards[(indexPath.section * cards.count / sections) + indexPath.row]
				cell.title.text = card.identifier
				cell.showBackCard()
			}
			
			card.index = (indexPath.section * rows) + indexPath.row
			cell.card = card
			return cell
		} else {
			fatalError("Error to get collection cell")
		}
	}
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if let cell = collectionView.cellForItem(at: indexPath) as? CardCellCollectionViewCell {
			//			cell.backgroundColor = UIColor(rgb: 0xBE5300)
			cell.showFrontCard()
			
			if let firstCard = firstCard {
				Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) {[weak self] timer in
					if firstCard.card.pair != cell.card.identifier {
						firstCard.showBackCard()
						cell.showBackCard()
					} else {
						self?.winStatus -= 1
						self?.checkWinCondition()
						firstCard.notShow()
						cell.notShow()
					}
				}
				self.firstCard = nil
			} else {
				firstCard = cell
			}
		}
	}
	
	func checkWinCondition() {
		if winStatus == 0 {
			let alert = UIAlertController(title: "Win", message: "Congrats you win! =D", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
				guard let cards = self?.cards else { return }
				for index in 0..<cards.count {
					self?.cards[index].show = true
				}
				self?.winStatus = cards.count / 2
				self?.collectionView.reloadData()
			})
			present(alert, animated: true)
		}
	}
}
