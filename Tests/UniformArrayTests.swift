//
//  UniformArrayTests.swift
//  MetalMemory
//
//  Created by Silvan Mosberger on 31/05/16.
//
//

import XCTest
import Metal
@testable import MetalMemory

class UniformArrayTests: XCTestCase {
	let device : MTLDevice = {
		if let device = MTLCreateSystemDefaultDevice() {
			return device
		} else {
			preconditionFailure("Cannot test without Metal")
		}
	}()
	
	func testTest() {
		let array = UniformArray<Int>()
		XCTAssertEqual(array.count, 0)
		
		array.count = 1000
		
		for i in 0..<1000 {
			array[i] = i
		}
		
		XCTAssert(array.count == 1000)
		
		for (i, v) in array.enumerate() {
			XCTAssertEqual(i, v)
		}
	}
	
	func testReplace() {
		let array = UniformArray<Int>()
		array.appendContentsOf(Array(0..<10000))
		
		for i in array.indices {
			XCTAssertEqual(array[i], i)
		}
		
		array.replaceRange(5000..<10000, with: [Int](count: 100, repeatedValue: 2000))
		
		for i in array.indices {
			if i < 5000 {
				XCTAssertEqual(array[i], i)
			} else {
				XCTAssertEqual(2000, array[i])
			}
		}
	}
	
	func testReserveCapacity() {
		let count = 1000
		
		let array = UniformArray<Int>()
		array.reserveCapacity(count)
		
		XCTAssertGreaterThan(array.memory.mem.bytes, strideof(Int) * count)
	}
	
	func testRepeatedValue() {
		let array = UniformArray<Int>(count: 1000, repeatedValue: 1000)
		
		XCTAssertEqual(array.count, 1000)
		
		for i in array.indices {
			XCTAssertEqual(array[i], 1000)
		}
	}
	
	func testAppend() {
		let array = UniformArray<Int>()
		
		array.appendContentsOf(0..<1000)
		
		XCTAssertEqual(array.count, 1000)
		
		array.append(1000)
		
		XCTAssertEqual(array.count, 1001)
				
		for i in array.indices {
			XCTAssertEqual(array[i], i)
		}
		
	}
	
	

}
