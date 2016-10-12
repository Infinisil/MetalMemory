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
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


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
		
		let pointer = buffer.contents().bindMemory(to: Int.self, capacity: 1)
		XCTAssertEqual(pointer.pointee, value)
		
		XCTAssert(buffer.length >= MemoryLayout<Int>.size)
	}
	
	func testDealloc() {
		uniform = nil
	}
	
	func testBigStructs() {
		func test<T>(_ t: T.Type) {
			var u : Uniform<T>? = Uniform()
			u?.device = device
			XCTAssert(u?.buffer.length >= MemoryLayout<T>.size)
			u = nil
		}
		
		
		test(Page.self)
		test(PagePlus1.self) // One more byte
		test(PageTimes8.self) // 8 times page size
		test(PageTimes8Plus1.self) // One more byte
		
		test(TenThousand.self) // 10_000 byte struct
	}
}

extension XCTestCase {
	final class FatalThread : Thread {
		let c : () -> ()
		let message : String
		
		init(c: @escaping () -> (), message: String = "") {
			self.c = c
			self.message = message
			super.init()
		}
		
		override func main() {
			c()
			XCTFail(message)
		}
	}
	
	func assertFatal<R>(message: String = "Method didn't fatal", timeout: TimeInterval = 1, c: @escaping () -> R) {
		expectedFatal = true
		
		let thread = FatalThread(c: { _ = c() }, message: message)
		
		expectation(forNotification: NSNotification.Name.NSThreadWillExit.rawValue, object: thread, handler: nil)
		
		thread.start()
		
		waitForExpectations(timeout: timeout) { error in
			expectedFatal = false
		}
	}
}
