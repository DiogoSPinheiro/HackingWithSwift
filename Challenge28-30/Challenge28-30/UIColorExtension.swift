//
//  UIColorExtension.swift
//  Challenge28-30
//
//  Created by Diogo Santiago Pinheiro on 12/03/22.
//

// https://stackoverflow.com/questions/35073272/button-text-uicolor-from-hex-swift

import UIKit

extension UIColor {
	
	convenience init(rgb: UInt) {
//		if let hexRGB = UInt("0x\(rgb)") {
			self.init(rgb: rgb, alpha: 1.0)
//		}
		self.init()
	}
	
	convenience init(rgb: UInt, alpha: CGFloat) {
		self.init(
			red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
			green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
			blue: CGFloat(rgb & 0x0000FF) / 255.0,
			alpha: CGFloat(alpha)
		)
	}
}
