//
//  EmptyView.swift
//  Challenge19-21
//
//  Created by Diogo Santiago Pinheiro on 09/03/22.
//

import UIKit

// MARK: - Testing xib, the correct way, is insert this flow in Main.storyboard as a viewcontroller

protocol EmptyViewDelegate {
	func createNode()
}

class EmptyView: UIView {
	
	var delegate: EmptyViewDelegate!
	@IBOutlet var contentView: UIView!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		initNib()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func initNib() {
		Bundle.main.loadNibNamed("EmptyView", owner: self, options: nil)
		addSubview(contentView)
		contentView.frame = self.bounds
		contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
	}
	
	@IBAction func createNote() {
		delegate.createNode()
	}
}
