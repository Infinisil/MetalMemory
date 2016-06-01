//
//  PolicyTest.swift
//  MetalMemory
//
//  Created by Silvan Mosberger on 31/05/16.
//
//

import XCTest
@testable import MetalMemory

class PolicyTest: XCTestCase {

	func testFLP() {
		let x = 80000
		
		print(roundUpToPowerOf2(x))
	}

	func testLimits() {
		print(roundUpToPowerOf2(Int.max >> 1))
	}
	
}
