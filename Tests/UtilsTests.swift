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

	func testIsPowerOfTwo() {
		let exp = (0..<10)
		
		let powers : Set<Int> = Set(exp.map{ 1 << $0 })
		
		for s in powers {
			XCTAssert((1 << s).isPowerOfTwo)
		}
		
		for i in 0..<(1 << exp.upperBound) where !powers.contains(i) {
			XCTAssertFalse(i.isPowerOfTwo)
		}
		
	}
	
}
