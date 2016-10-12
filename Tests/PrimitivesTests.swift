//
//  PrimitivesTests.swift
//  MetalMemory
//
//  Created by Silvan Mosberger on 12.10.16.
//
//

import XCTest
@testable import MetalMemory

class PrimitivesTests: XCTestCase {

	let pageSize = NSPageSize()
	
	func testConstPageMemory() {
		for i in stride(from: 0, through: pageSize * 4, by: 1) {
			let m = ConstPageMemory(bytes: i)
			XCTAssertGreaterThanOrEqual(m.bytes, i)
			XCTAssertEqual(m.bytes % pageSize, 0)
			XCTAssertLessThan(m.bytes, i + pageSize)
		}
	}
	
	func testPageMemoryInit() {
		let m = PageMemory(bytes: 1000, policy: Policy(rounding: .pageMultiple, decrease: true))
		var ints = m.mem.pointer.bindMemory(to: Int.self, capacity: 10)
		m.movedCallbacks.append { ptr, bytes in
			ints = ptr.bindMemory(to: Int.self, capacity: 10)
		}
		
		for i in 0..<10 {
			ints[i] = i
		}
		
		m.bytes += 10000
		
		for i in 0..<10 {
			XCTAssertEqual(i, ints[i])
		}
		
	}
}
