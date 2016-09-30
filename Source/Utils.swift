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

func roundUpToPowerOf2(_ n: Int) -> Int {
	var n = n - 1
	var shift = 1
	while (n+1) & n != 0 {
		n |= n >> shift
		shift <<= 1
	}
	return n + 1
}

// Fatal error mocking, to be able to test an expected fatal
var expectedFatal = false

#if DEBUG
func fatalError(_ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) -> Never {
	if expectedFatal { Thread.exit() }
	Swift.fatalError(message, file: file, line: line)
}
#endif
