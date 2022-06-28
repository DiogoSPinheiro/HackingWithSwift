//
//  ViewController.swift
//  Project27
//
//  Created by Diogo Santiago Pinheiro on 06/03/22.
//

import UIKit


class ViewController: UIViewController {

	@IBOutlet var imageView: UIImageView!
	var currentDrawType = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		drawRectangle()
	}


	@IBAction func redrawTapped(_ sender: UIButton) {
		currentDrawType += 1
		
		if currentDrawType > 6 {
			currentDrawType = 0
		}
		
		switch currentDrawType {
		case 0: drawRectangle()
		case 1: drawCircle()
		case 2: drawCheckerboard()
		case 3: drawRotateSquares()
		case 4: drawLines()
		case 5: drawImagesAndText()
		case 6: drawEmoji()
		default: break
		}
	}
	
	func drawRectangle() {
		let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
		
		let image = renderer.image { ctx in
			let rect = CGRect(x: 0, y: 0, width: 512, height: 512)
			
			ctx.cgContext.setFillColor(UIColor.red.cgColor)
			ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
			ctx.cgContext.setLineWidth(10)
			
			ctx.cgContext.addRect(rect)
			ctx.cgContext.drawPath(using: .fillStroke)
		}
		
		imageView.image = image
		
	}
	
	func drawCircle() {
		let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
		
		let image = renderer.image { ctx in
			let rect = CGRect(x: 5, y: 5, width: 502, height: 502).insetBy(dx: 5, dy: 5)
			
			ctx.cgContext.setFillColor(UIColor.red.cgColor)
			ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
			ctx.cgContext.setLineWidth(10)
			
			ctx.cgContext.addEllipse(in: rect)
			ctx.cgContext.drawPath(using: .fillStroke)
		}
		
		imageView.image = image
	}
	
	func drawCheckerboard() {
		let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
		
		let image = renderer.image { ctx in
			ctx.cgContext.setFillColor(UIColor.black.cgColor)
			
			for row in 0..<8 {
				for col in 0..<8 {
					if (row + col).isMultiple(of: 2) {
						ctx.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
					}
				}
			}
		}
		
		imageView.image = image
	}
	
	func drawRotateSquares() {
		let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
		
		let image = renderer.image { ctx in
			ctx.cgContext.translateBy(x: 256, y: 256)
			
			let rotation = 16
			let amount = Double.pi / Double(rotation)
			
			for _ in 0..<rotation {
				ctx.cgContext.rotate(by: CGFloat(amount))
				ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
			}
			
			ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
			ctx.cgContext.strokePath()
			
		}
		
		imageView.image = image
	}
	
	func drawLines() {
		let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
		
		let image = renderer.image { ctx in
			ctx.cgContext.translateBy(x: 256, y: 256)
			
			var first = true
			var length: CGFloat = 256
			
			for _ in 0..<256 {
				ctx.cgContext.rotate(by: .pi / 2)
				
				if first {
					ctx.cgContext.move(to: CGPoint(x: length, y: 50))
					first = false
				} else {
					ctx.cgContext.addLine(to: CGPoint(x: length, y: 50))
				}
				length *= 0.99
			}
			
			ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
			ctx.cgContext.strokePath()
			
		}
		
		imageView.image = image
	}
	
	func drawImagesAndText() {
		let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
		
		let image = renderer.image { ctx in
			let paragraphStyle = NSMutableParagraphStyle()
			paragraphStyle.alignment = .center
			
			let attrs: [NSAttributedString.Key: Any] = [
				.font: UIFont.systemFont(ofSize: 36),
				.paragraphStyle: paragraphStyle
			]
			
			let string = "The best-laid schemes o'\nmice an' men gang aft agley"
			
			let attributtedString = NSAttributedString(string: string, attributes: attrs)
			
			attributtedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
			
			let mouse = UIImage(named: "mouse")
			mouse?.draw(at: CGPoint(x: 300, y: 150))
			
		}
		
		imageView.image = image
	}
	
	func drawEmoji() {
		let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
		
		let image = renderer.image { ctx in
			let rect = CGRect(x: 10, y: 10, width: 502, height: 502).insetBy(dx: 10, dy: 10)
			
			let eye1 = CGRect(x: 100, y: 100, width: 100, height: 100)
			let eye2 = CGRect(x: 330, y: 100, width: 100, height: 100)
			let mouth = CGRect(x: 210, y: 260, width: 100, height: 200)
			
			
			ctx.cgContext.addEllipse(in: rect)
			ctx.cgContext.setFillColor(UIColor.yellow.cgColor)
			ctx.cgContext.fillEllipse(in: rect)
			
			ctx.cgContext.setFillColor(UIColor.orange.cgColor)
			ctx.cgContext.addEllipse(in: eye1)
			ctx.cgContext.addEllipse(in: eye2)
			ctx.cgContext.addEllipse(in: mouth)
			ctx.cgContext.fillEllipse(in: eye1)
			ctx.cgContext.fillEllipse(in: eye2)
			ctx.cgContext.fillEllipse(in: mouth)
			
			ctx.cgContext.drawPath(using: .fill)
		}
		
		imageView.image = image
	}
}

