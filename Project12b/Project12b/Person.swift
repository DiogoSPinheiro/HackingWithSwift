//
//  Person.swift
//  Project10
//
//  Created by Diogo Santiago Pinheiro on 03/03/22.
//

import UIKit

class Person: NSObject, Codable {
	var name: String
	var image: String
	
	init(name: String, image: String) {
		self.name = name
		self.image = image
	}
	
}
