//
//  UniformTests.swift
//  MetalMemory
//
//  Created by Silvan Mosberger on 20/05/16.
//
//

import XCTest
@testable import MetalMemory

class FatalTests: XCTestCase {
	let value = 1
	
	var valueLess : Uniform<Int>!
	var uniform : Uniform<Int>!
	
	let device : MTLDevice = {
		if let device = MTLCreateSystemDefaultDevice() {
			return device
		} else {
			preconditionFailure("Cannot test without Metal")
		}
	}()
	
	override func setUp() {
		valueLess = Uniform()
		uniform = Uniform(value: value)
	}
	
	func testInit() {
		XCTAssertEqual(valueLess.memory, 0)
		XCTAssertEqual(uniform.memory, value)
		
		assertFatal { self.valueLess.metalBuffer }
		assertFatal { self.uniform.metalBuffer }
	}
	
	func testZeroSize() {
		assertFatal { Uniform<()>() }
	}

	func testMemory() {
		let value = 10
		
		uniform.memory = value
		XCTAssertEqual(uniform.memory, value)
	}
	
	func assignDevice() {
		valueLess.device = device
		uniform.device = device
	}
	
	func testLabel() {
		let string = "Test"
		
		XCTAssertNil(uniform.label)
		uniform.label = string
		XCTAssertEqual(uniform.label, string)
		
		uniform.device = device
		
		XCTAssertEqual(uniform.metalBuffer.label, string)
		
		uniform.device = nil
		uniform.device = device
		
		XCTAssertEqual(uniform.metalBuffer.label, string)
	}

	func testBuffer() {
		uniform.device = device
		XCTAssert(uniform.device === device)
		
		let buffer = uniform.metalBuffer
		XCTAssert(buffer.device === device)
		
		let pointer = UnsafeMutablePointer<Int>(buffer.contents())
		XCTAssertEqual(pointer.memory, value)
		
		XCTAssert(buffer.length >= sizeofValue(Int))
	}
	
	func testDealloc() {
		uniform = nil
	}
	
	func testBigStructs() {
		func test<T>(t: T.Type) {
			var u : Uniform<T>? = Uniform()
			u?.device = device
			XCTAssert(u?.metalBuffer.length >= sizeof(T))
			u = nil
		}
		
		test(S1)
		test(S2)
		test(S3)
		test(S4)
		test(S5)
	}
}

extension XCTestCase {
	class FatalThread : NSThread {
		let c : () -> ()
		let message : String
		
		init(c: () -> (), message: String = "") {
			self.c = c
			self.message = message
			super.init()
		}
		
		override func main() {
			c()
			XCTFail(message)
		}
	}
	
	func assertFatal<R>(message message: String = "Method didn't fatal", timeout: NSTimeInterval = 1, c: () -> R) {
		expectedFatal = true
		
		let thread = FatalThread(c: { _ = c() }, message: message)
		
		expectationForNotification(NSThreadWillExitNotification, object: thread, handler: nil)
		
		thread.start()
		
		waitForExpectationsWithTimeout(timeout) { error in
			expectedFatal = false
		}
	}
}