//
//  main.swift
//  TestGenerator
//
//  Created by Silvan Mosberger on 25/07/16.
//
//

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
		case .Decimal: return (0..<10).map{ "N\($0)" }
		}
	}
}

func testSize(n: Int, base: Base) -> String {
	assert(n >= 0)
	var v = n
	var typePath = ""
	while v > 0 {
		typePath = ".\(base.subTypes[v % base.rawValue])" + typePath
		v /= base.rawValue
	}
	
	return "XCTAssertEqual(sizeof(\(base.baseType)\(typePath).self), \(base.prefix)\(String(n, radix: base.rawValue)))"
}

func testInstantiation(n: Int, base: Base) -> String {
	
}


for base in Base.all {
	for n in 0..<10 {
		print(test(n, base: base))
	}
	
	for i in 2..<14 {
		print(test(Int(Double(arc4random()) / Double(UInt32.max) * pow(10, Double(i))), base: base))
	}
}
