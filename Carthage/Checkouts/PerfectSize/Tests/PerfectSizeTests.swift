//
//  PerfectSizeTests.swift
//  PerfectSizeTests
//
//  Created by Silvan Mosberger on 25/07/16.
//
//

import XCTest
@testable import PerfectSize

class PerfectSizeTests: XCTestCase {
	func testBinary() {
		XCTAssertEqual(sizeof(B.self), 0b0)
		XCTAssertEqual(sizeof(B.I.self), 0b1)
		XCTAssertEqual(sizeof(B.I.O.self), 0b10)
		XCTAssertEqual(sizeof(B.I.I.self), 0b11)
		XCTAssertEqual(sizeof(B.I.O.O.self), 0b100)
		XCTAssertEqual(sizeof(B.I.O.I.self), 0b101)
		XCTAssertEqual(sizeof(B.I.I.O.self), 0b110)
		XCTAssertEqual(sizeof(B.I.I.I.self), 0b111)
		XCTAssertEqual(sizeof(B.I.O.O.O.self), 0b1000)
		XCTAssertEqual(sizeof(B.I.O.O.I.self), 0b1001)
		XCTAssertEqual(sizeof(B.I.O.O.I.I.O.self), 0b100110)
		XCTAssertEqual(sizeof(B.I.O.I.O.I.I.O.I.I.self), 0b101011011)
		XCTAssertEqual(sizeof(B.I.I.O.O.O.O.I.I.self), 0b11000011)
		XCTAssertEqual(sizeof(B.I.I.O.I.O.I.I.O.O.O.I.I.I.I.O.O.self), 0b1101011000111100)
		XCTAssertEqual(sizeof(B.I.I.I.I.I.I.O.I.O.O.O.O.O.I.I.self), 0b111111010000011)
		XCTAssertEqual(sizeof(B.I.I.I.I.O.I.O.O.I.I.I.I.O.O.I.O.O.O.O.I.I.I.I.self), 0b11110100111100100001111)
		XCTAssertEqual(sizeof(B.I.I.I.O.O.O.O.I.O.O.I.O.O.O.I.O.O.O.I.O.O.I.I.O.O.O.self), 0b11100001001000100010011000)
		XCTAssertEqual(sizeof(B.I.I.I.I.O.O.O.O.O.O.I.O.O.I.I.O.I.O.I.I.I.I.O.I.O.I.O.O.O.self), 0b11110000001001101011110101000)
		XCTAssertEqual(sizeof(B.I.O.O.O.O.I.I.I.O.O.I.I.I.O.O.I.O.O.O.O.O.I.I.O.I.I.I.I.O.I.O.self), 0b1000011100111001000001101111010)
		XCTAssertEqual(sizeof(B.I.O.O.I.I.O.I.O.O.O.I.I.O.O.O.I.O.I.I.I.O.I.I.O.O.I.I.O.O.I.O.O.O.O.self), 0b1001101000110001011101100110010000)
		XCTAssertEqual(sizeof(B.I.O.I.I.I.O.O.O.O.I.I.O.I.O.O.I.O.I.O.O.O.I.O.I.I.O.I.O.O.O.I.I.I.I.O.O.I.O.O.self), 0b101110000110100101000101101000111100100)
		XCTAssertEqual(sizeof(B.I.I.O.I.O.O.I.I.I.I.O.I.O.O.I.I.O.O.O.I.I.I.O.I.O.O.I.O.O.O.O.O.I.I.I.I.O.I.O.I.I.I.I.self), 0b1101001111010011000111010010000011110101111)
	}
	
	func testDecimal() {
		XCTAssertEqual(sizeof(D.self), 0)
		XCTAssertEqual(sizeof(D.n1.self), 1)
		XCTAssertEqual(sizeof(D.n2.self), 2)
		XCTAssertEqual(sizeof(D.n3.self), 3)
		XCTAssertEqual(sizeof(D.n4.self), 4)
		XCTAssertEqual(sizeof(D.n5.self), 5)
		XCTAssertEqual(sizeof(D.n6.self), 6)
		XCTAssertEqual(sizeof(D.n7.self), 7)
		XCTAssertEqual(sizeof(D.n8.self), 8)
		XCTAssertEqual(sizeof(D.n9.self), 9)
		XCTAssertEqual(sizeof(D.n3.n1.self), 31)
		XCTAssertEqual(sizeof(D.n3.n0.n6.self), 306)
		XCTAssertEqual(sizeof(D.n4.n5.n1.n4.self), 4514)
		XCTAssertEqual(sizeof(D.n6.n2.n7.n2.n3.self), 62723)
		XCTAssertEqual(sizeof(D.n5.n4.n5.n6.n6.n1.self), 545661)
		XCTAssertEqual(sizeof(D.n8.n8.n7.n2.n6.n9.n9.self), 8872699)
		XCTAssertEqual(sizeof(D.n6.n4.n5.n3.n9.n4.n7.n5.self), 64539475)
		XCTAssertEqual(sizeof(D.n1.n8.n6.n9.n0.n7.n2.n9.n5.self), 186907295)
		XCTAssertEqual(sizeof(D.n2.n6.n2.n8.n2.n9.n7.n8.n9.n7.self), 2628297897)
		XCTAssertEqual(sizeof(D.n1.n0.n6.n9.n8.n2.n7.n2.n1.n9.n7.self), 10698272197)
		XCTAssertEqual(sizeof(D.n2.n9.n8.n6.n8.n7.n1.n7.n9.n8.n7.n5.self), 298687179875)
		XCTAssertEqual(sizeof(D.n8.n4.n6.n1.n7.n1.n1.n9.n4.n1.n8.n6.n0.self), 8461711941860)
	}
}

