//
//  PolicyTests.swift
//  MetalMemory
//
//  Created by Silvan Mosberger on 12.10.16.
//
//

import XCTest
@testable import MetalMemory

class PolicyTests: XCTestCase {
	
	let pageSize = NSPageSize()
	
	func testRoundingPageMultiple() {
		let r = Policy.Rounding.pageMultiple
		
		for i in stride(from: 0, through: pageSize * 4, by: 1) {
			let needed = r.bytesNeeded(i)
			XCTAssertGreaterThanOrEqual(needed, i)
			XCTAssertEqual(needed % pageSize, 0)
			XCTAssertLessThan(needed, i + pageSize)
		}
	}
	
	func testRoundingPowerOf2() {
		let r = Policy.Rounding.powerOfTwo
		
		for i in stride(from: 0, through: pageSize * 10, by: 1) {
			let needed = r.bytesNeeded(i)
			XCTAssertGreaterThanOrEqual(needed, i)
			if i > 0 { XCTAssert(needed.isPowerOfTwo) }
			XCTAssertLessThan(needed, (i + pageSize) * 2)
		}
	}
	
	func testDecreasing() {
		func test(p: Policy, old: Int, new: Int) {
			let result = p.bytesNeeded(oldBytes: old, newBytes: new)
			
			XCTAssertGreaterThanOrEqual(result, new)
			if p.decrease {
				XCTAssertEqual(result, p.rounding.bytesNeeded(new))
			} else {
				XCTAssertGreaterThanOrEqual(result, old)
			}
		}
		
		for rounding in [Policy.Rounding.pageMultiple, Policy.Rounding.powerOfTwo] {
			for decrease in [false, true] {
				let p = Policy(rounding: rounding, decrease: decrease)
				
				let cases : [(old: Int, new: Int)] = [
					(0, 0),
					(0, 1),
					(1, 0),
					(1, 1),
					(0, 100),
					(100, 0),
					(10, 20),
					(38024, 204),
					(2003, 294720),
					(pageSize, pageSize + 1),
					(pageSize + 1, pageSize),
					(pageSize * 3, pageSize * 3 + 1)
				]
				
				cases.forEach { old, new in
					test(p: p, old: old, new: new)
				}
			}
		}
	}
}

