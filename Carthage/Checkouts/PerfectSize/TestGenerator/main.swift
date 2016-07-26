//
//  main.swift
//  TestGenerator
//
//  Created by Silvan Mosberger on 25/07/16.
//
//

import Darwin

enum Base : Int {
	case Binary = 2
	case Decimal = 10
	
	static let all = [Binary, Decimal]
	
	var prefix : String {
		switch self {
		case .Binary: return "0b"
		case .Decimal: return ""
		}
	}
	
	var baseType : String {
		switch self {
		case .Binary: return "B"
		case .Decimal: return "D"
		}
	}
	
	var subTypes : [String] {
		switch self {
		case .Binary: return ["O", "I"]
		case .Decimal: return (0..<10).map{ "n\($0)" }
		}
	}
}

typealias Number = (n: Int, base: Base)

func typePathForNumber(n: Number) -> String {
	let (n, base) = n
	assert(n >= 0)
	var v = n
	var typePath = ""
	while v > 0 {
		typePath = ".\(base.subTypes[v % base.rawValue])" + typePath
		v /= base.rawValue
	}
	return "\(base.baseType)\(typePath)"
}

func literalForNumber(n: Number) -> String {
	return "\(n.base.prefix)\(String(n.n, radix: n.base.rawValue))"
}

func testEqual(a: String, _ b: String) {
	print("XCTAssertEqual(\(a), \(b))")
}

func testSize(n: Number) {
	testEqual("sizeof(\(typePathForNumber(n)).self)", "\(literalForNumber(n))")
}

extension Int {
	static func random(min min: Int = 0, max: Int) -> Int {
		return min + Int(arc4random_uniform(UInt32(max - min + 1)))
	}
	
	static func random(maxDigits maxDigits: Int) -> Int {
		return random(digits: random(max: maxDigits))
	}
	
	static func random(digits digits: Int) -> Int {
		return Int(Double(arc4random()) / Double(UInt32.max) * pow(10, Double(digits)))
	}
}

for base in Base.all {
	for n in 0..<10 {
		testSize((n, base))
	}
	
	for i in 2..<14 {
		let number = (Int.random(digits: i), base)
		testSize(number)
	}
}

func testSum(numbers: [Number]) {
	let lhs = "sizeof((\(numbers.map(typePathForNumber).map{ "\($0).self" }.joinWithSeparator(" + "))).self)"
	let rhs = numbers.map(literalForNumber).joinWithSeparator(" + ")
	testEqual(lhs, rhs)
}

for _ in 0..<10 {
	let terms = 0..<Int.random(min: 2, max: 4)
	let values = terms.map{ _ in Int.random(maxDigits: 5) }
	let bases = terms.map{ _ in Base.all[Int(arc4random_uniform(UInt32(Base.all.count)))] }
	
	let numbers : [Number] = Array(zip(values, bases))
	
	testSum(numbers)
}
