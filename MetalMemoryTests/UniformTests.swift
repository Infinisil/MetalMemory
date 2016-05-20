//
//  UniformTests.swift
//  MetalMemory
//
//  Created by Silvan Mosberger on 20/05/16.
//
//

import XCTest
import MetalMemory

class UniformTests: XCTestCase {
	var device : MTLDevice!
	
	override func setUp() {
		super.setUp()
		guard let device = MTLCreateSystemDefaultDevice() else {
			fatalError("Cannot test without available metal device")
		}
		self.device = device
	}
	
	func testInit() {
		let value = 1
		let string = "Test"
		
		let uniform = Uniform(value: value, device: device, label: string)
		XCTAssertEqual(uniform.label, string)
		XCTAssertEqual(uniform.memory, value)
	}

}
