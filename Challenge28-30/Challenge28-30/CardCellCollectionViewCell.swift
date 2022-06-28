//
//  CardCellCollectionViewCell.swift
//  Challenge28-30
//
//  Created by Diogo Santiago Pinheiro on 12/03/22.
//

import UIKit

class CardCellCollectionViewCell: UICollectionViewCell {
    
	@IBOutlet var title: UILabel!
	var card: CardCell!
	
	func showBackCard() {
		self.backgroundColor = .systemCyan
		self.isUserInteractionEnabled = true
		title.text = ""
	}
	
	func showFrontCard() {
		self.backgroundColor = .clear
		title.text = card.identifier
	}
	
	func notShow() {
		self.backgroundColor = UIColor.white
		self.isUserInteractionEnabled = false
		title.text = ""
		card.show = false
	}
}
