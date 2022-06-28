//
//  CreateCardViewControllerViewController.swift
//  Challenge28-30
//
//  Created by Diogo Santiago Pinheiro on 12/03/22.
//

import UIKit

class CreateCardViewControllerViewController: UIViewController {

	@IBOutlet var firstCard: UITextField!
	@IBOutlet var secondCard: UITextField!
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	
	@IBAction func saveCards(_ sender: UIButton) {
		
		if let firstCard = firstCard.text,
		   let secondCard = secondCard.text {
			if firstCard.isEmpty || secondCard.isEmpty {
				let alert = UIAlertController(title: "Error", message: "One of cards are empty", preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "Ok", style: .default))
				present(alert, animated: true)
			} else {
				UserDefaultsManager.singleton.store(cardCell: CardCell(index: nil, identifier: firstCard, pair: secondCard, colorBackground: nil, show: nil))
				UserDefaultsManager.singleton.store(cardCell: CardCell(index: nil, identifier: secondCard, pair: firstCard, colorBackground: nil, show: nil))
				navigationController?.popViewController(animated: true)
			}
		}
	}
}
