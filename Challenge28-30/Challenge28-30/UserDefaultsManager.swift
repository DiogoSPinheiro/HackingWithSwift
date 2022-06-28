//
//  UserDefaultsManager.swift
//  Challenge28-30
//
//  Created by Diogo Santiago Pinheiro on 12/03/22.
//

import Foundation

class UserDefaultsManager {
	
	static var singleton = UserDefaultsManager()
	
	var defaultCards: [CardCell] = [
		CardCell(index: 0, identifier: "amarelo", pair: "yellow", colorBackground: "FFFF00", show: true),
		CardCell(index: 1,identifier: "yellow", pair: "amarelo", colorBackground: "FFFF00", show: true),
		CardCell(index: 2,identifier: "azul", pair: "blue", colorBackground: "blue", show: true),
		CardCell(index: 3,identifier: "blue", pair: "azul", colorBackground: "blue", show: true),
		CardCell(index: 4,identifier: "green", pair: "verde", colorBackground: "green", show: true),
		CardCell(index: 5,identifier: "verde", pair: "green", colorBackground: "green", show: true),
		CardCell(index: 6,identifier: "laranja", pair: "orange", colorBackground: "orange", show: true),
		CardCell(index: 7,identifier: "orange", pair: "laranja", colorBackground: "orange", show: true),
		CardCell(index: 8,identifier: "vermelho", pair: "red", colorBackground: "red", show: true),
		CardCell(index: 9,identifier: "red", pair: "vermelho", colorBackground: "red", show: true),
		CardCell(index: 10,identifier: "roxo", pair: "purple", colorBackground: "purple", show: true),
		CardCell(index: 11,identifier: "purple", pair: "roxo", colorBackground: "purple", show: true),
		CardCell(index: 12,identifier: "marrom", pair: "brown", colorBackground: "brown", show: true),
		CardCell(index: 13,identifier: "brown", pair: "marrom", colorBackground: "brown", show: true),
		CardCell(index: 14,identifier: "cinza", pair: "gray", colorBackground: "gray", show: true),
		CardCell(index: 15,identifier: "gray", pair: "cinza", colorBackground: "gray", show: true)
	]
	
	func store(cardCell: CardCell) {
		var cards = retrieve()
		cards.append(cardCell)
		do {
			let encodedCell = try JSONEncoder().encode(cards)
			UserDefaults.standard.set(encodedCell, forKey: "cardCells")
		} catch {
			fatalError("Cant save cell")
		}
	}
	
	func removeCell(cardName: String) {
		var cards = retrieve()
		if let cardIndex = cards.firstIndex(where: { $0.identifier == cardName }) {
			cards.remove(at: cardIndex)
			do {
				let encodedCell = try JSONEncoder().encode(cards)
				UserDefaults.standard.set(encodedCell, forKey: "cardCells")
			} catch {
				fatalError("Cant save cell")
			}
		}
	}
	
	func retrieve() -> [CardCell] {
		
		if let cards = UserDefaults.standard.object(forKey: "cardCells") as? Data {
			do {
			let decodedCards = try JSONDecoder().decode([CardCell].self, from: cards)
				return decodedCards
			} catch {
				fatalError("Cant load cards")
			}
		} else {
			do {
				let encodedCards = try JSONEncoder().encode(defaultCards)
				UserDefaults.standard.set(encodedCards, forKey: "cardCells")
			} catch {
				fatalError("Cant save cells")
			}
			return defaultCards
		}
	}
}
