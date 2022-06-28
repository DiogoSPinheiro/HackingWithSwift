//
//  Country.swift
//  Challenge13-15
//
//  Created by Diogo Santiago Pinheiro on 05/03/22.
//

struct Countries: Codable {
	var countries: [Country]
	
	init() {
		countries = []
	}
}

struct Country: Codable {
	var name: String
	var code: String
	var capital: String
	var currency: String
	var fact: String
}
