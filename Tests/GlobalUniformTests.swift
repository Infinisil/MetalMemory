//
//  GlobalUniformTests.swift
//  MetalMemory
//
//  Created by Silvan Mosberger on 23/05/16.
//  
//

import XCTest
import Metal
@testable import MetalMemory

class GlobalUniformTests : XCTestCase {
	let device : MTLDevice = {
		if let device = MTLCreateSystemDefaultDevice() {
			return device
		} else {
			preconditionFailure("Cannot test without Metal")
		}
	}()
	
	func testInit() {
		let a = GlobalUniform<Int>()
		a.value = 10
		XCTAssertEqual(a.value, 10)
		
		let b = GlobalUniform<Bool>()
		b.value = true
		XCTAssertEqual(b.value, true)
		
	}
	
	func testBig() {
		let a = GlobalUniform<TenThousand>()
		
		globalUniformDevice = device
		XCTAssert(a.buffer.length > sizeof(TenThousand) + 1)
	}
	
	func testA() {
		let u = GlobalUniform<Int>()
		
		u.value = 10
		_ = GlobalUniform<TenThousand>()

		XCTAssertEqual(u.value, 10)
	
	}
	
}
