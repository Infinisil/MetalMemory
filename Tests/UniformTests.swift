//
//  UniformTests.swift
//  MetalMemory
//
//  Created by Silvan Mosberger on 20/05/16.
//
//

import XCTest
import PerfectSize
@testable import MetalMemory

class UniformTests: XCTestCase {
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
		XCTAssertEqual(valueLess.value, 0)
		XCTAssertEqual(uniform.value, value)
		
		assertFatal { self.valueLess.buffer }
		assertFatal { self.uniform.buffer }
	}
	
	func testZeroSize() {
		_ = Uniform<()>()
	}

	func testMemory() {
		let value = 10
		
		uniform.value = value
		XCTAssertEqual(uniform.value, value)
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
		
		XCTAssertEqual(uniform.buffer.label, string)
		
		uniform.device = nil
		uniform.device = device
		
		XCTAssertEqual(uniform.buffer.label, string)
	}

	func testBuffer() {
		uniform.device = device
		XCTAssert(uniform.device === device)
		
		let buffer = uniform.buffer
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
			XCTAssert(u?.buffer.length >= sizeof(T))
			u = nil
		}
		
		
		test(Page)
		test(PagePlus1) // One more byte
		test(PageTimes8) // 8 times page size
		test(PageTimes8Plus1) // One more byte
		
		test(TenThousand) // 10_000 byte struct
	}
}

extension XCTestCase {
	final class FatalThread : NSThread {
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