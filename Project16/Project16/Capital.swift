//
//  Capital.swift
//  Project16
//
//  Created by Diogo Santiago Pinheiro on 05/03/22.
//

import MapKit
import UIKit

class Capital: NSObject, MKAnnotation {
	var title: String?
	var link: String
	var coordinate: CLLocationCoordinate2D
	var info: String
	
	init(title: String, link: String, coordinate: CLLocationCoordinate2D, info: String) {
		self.title = title
		self.link = link
		self.coordinate = coordinate
		self.info = info
	}
}
