//
//  UtilsTests.swift
//  MetalMemory
//
//  Created by Silvan Mosberger on 12.10.16.
//
//

import XCTest
@testable import MetalMemory

class UtilsTests: XCTestCase {

	func testIsPowerOf2() {
		let exp = (0..<10)
		
		let powers : Set<Int> = Set(exp.map{ 1 << $0 })
		
		for s in powers {
			XCTAssert(s.isPowerOfTwo)
		}
		
		for i in 0..<(1 << exp.upperBound) where !powers.contains(i) {
			XCTAssertFalse(i.isPowerOfTwo)
		}
		
	}
	
	func testNextPowerOf2() {
		let exp = (0..<10)
		
		let powers = exp.map{ 1 << $0 }
		
		XCTAssertEqual(0.nextPowerOf2(), 0)
		XCTAssertEqual(1.nextPowerOf2(), 1)
		
		for (a, b) in zip(powers, powers.dropFirst()) {
			for i in a+1 ... b {
				XCTAssertEqual(i.nextPowerOf2(), b)
			}
		}
	}
	
}
