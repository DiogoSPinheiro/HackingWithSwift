import UIKit
import Foundation

let name = "Test"

for letter in name {
	print("Give me a \(letter)")
}

let letter = name[name.index(name.startIndex, offsetBy: 3)]

extension String {
	subscript(i: Int) -> String {
		return String(self[index(startIndex, offsetBy: i)])
	}
	
	func deletingPrefix(_ prefix: String) -> String {
		guard self.hasPrefix(prefix) else { return self }
		return String(self.dropFirst(prefix.count))
	}
	
	func deletingSuffix(_ suffix: String) -> String {
		guard self.hasSuffix(suffix) else { return self }
		return String(self.dropLast(suffix.count))
	}
	
	var capitalizedFirst: String {
		guard let firstLetter = self.first else { return " "}
		return firstLetter.uppercased() + self.dropFirst()
	}
	
	func containsAny(of array: [String]) -> Bool {
		for item in array {
			if self.contains(item) {
				return true
			}
		}
		return false
	}
	
	func withPrefix(_ prefix: String) -> String {
		guard !self.hasPrefix(prefix) else { return self }
		return prefix + self
	}
	
	func isNumeric(_ number: String) -> Bool {
		return Double(number) != nil
	}
	
	func separeteLinesByArray(separator: Character = "\n") -> [String] {
		let splitted = self.split(separator: separator)
		return splitted.map({String($0)})
	}
}

let challenge = "This is the challenge\nBe Prepared"
let number = "-8978.0"

challenge.withPrefix("Wow, ")
challenge.withPrefix("This is")
challenge.isNumeric(number)
print(challenge.separeteLinesByArray(separator: "\n"))
print(challenge.separeteLinesByArray(separator: " "))




let letter2 = name[3]

let password = "123456"
password.hasPrefix("123")
password.hasSuffix("456")
password.deletingPrefix("1")
password.deletingSuffix("6")

let weather = "it's going to rain"
let days = ["Monday", "Tuesday", "Wednesday"]
weather.capitalizedFirst
print(weather.capitalized)

weather.contains("going")
days.contains("Monday")
"Monday".containsAny(of: days)

days.contains(where: "Monday".contains)

let test = "This is a test string"

let attributes: [NSAttributedString.Key: Any] = [
	.foregroundColor: UIColor.white,
	.backgroundColor: UIColor.red,
	.font: UIFont.boldSystemFont(ofSize: 36)
]

let attributedString = NSAttributedString(string: weather, attributes: attributes)

let attributedMutableString = NSMutableAttributedString(string: test)

attributedMutableString.addAttributes([.font: UIFont.systemFont(ofSize: 8)], range: NSRange(location: 0, length: 4))
attributedMutableString.addAttributes([.font: UIFont.systemFont(ofSize: 16)], range: NSRange(location: 5, length: 2))
attributedMutableString.addAttributes([.font: UIFont.systemFont(ofSize: 24)], range: NSRange(location: 8, length: 1))
attributedMutableString.addAttributes([.font: UIFont.systemFont(ofSize: 32)], range: NSRange(location: 10, length: 4))
attributedMutableString.addAttributes([.font: UIFont.systemFont(ofSize: 40)], range: NSRange(location: 15, length: 6))
