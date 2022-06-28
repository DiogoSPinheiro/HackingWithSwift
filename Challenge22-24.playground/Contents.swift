//Extend UIView so that it has a bounceOut(duration:) method that uses animation to scale its size down to 0.0001 over a specified number of seconds.
//Extend Int with a times() method that runs a closure as many times as the number is high. For example, 5.times { print("Hello!") } will print “Hello” five times.
//Extend Array so that it has a mutating remove(item:) method. If the item exists more than once, it should remove only the first instance it finds. Tip: you will need to add the Comparable constraint to make this work!

import UIKit

extension UIView {
	func bounceOut(duration: Double) {
		UIView.animate(withDuration: duration) {
			self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
		}
	}
}

extension Int {
	func times(_ closure: () -> Void) {
		for _ in 0..<self {
			closure()
		}
	}
}

extension Array where Element: Comparable{
	mutating func remove(item: Element) {
		
		guard let first = self.firstIndex(of: item) else { return }
		self.remove(at: first)
	}
}


UIView().bounceOut(duration: 1)

5.times() {
	print("Hello")
}

var array = [1,2,3,3,4,5]

array.remove(item: 3)
array.remove(item: 3)
array.remove(item: 3)
