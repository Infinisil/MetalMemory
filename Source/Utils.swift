//
//  Utils.swift
//  MetalMemory
//
//  Created by Silvan Mosberger on 20/05/16.
//  
//

import Foundation
import Willow

let log = Logger(configuration: LoggerConfiguration.timestampConfiguration())

extension Int {
	/// Returns whether this number is a power of 2
	var isPowerOfTwo : Bool {
		if self < 1 { return false }
		return self & (self - 1) == 0
	}
	
	/**
	Returns the next power of 2 that is bigger or equal to this number. Returns 0 on 0.
	
	Complexity: O(log(log(n))) where n is the input number
	*/
	func nextPowerOf2() -> Int {
		var n = self - 1		// If self is already a power of 2, n is going to be 000...000111...111 from the start
		var shift = 1
		while (n+1) & n != 0 {	// While n isn't of the form 000...000111...111
			n |= n >> shift		// Or all bits `shift` places to the right, e.g. 1010000 -> 1111000 -> 1111110 -> 1111111
			shift <<= 1			// Double `shift`
		}
		return n + 1			// Return 000...000111...111 + 1 = 000...0001000...000
	}
}



#if DEBUG
// Fatal error mocking, to be able to test an expected fatal
var expectedFatal = false
func fatalError(_ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) -> Never {
	if expectedFatal { Thread.exit() }
	Swift.fatalError(message, file: file, line: line)
}
#endif
