//
//  Utils.swift
//  MetalMemory
//
//  Created by Silvan Mosberger on 20/05/16.
//  
//

import Foundation

func roundUpToPowerOf2(n: Int) -> Int {
	var n = n - 1
	var shift = 1
	while (n+1) & n != 0 {
		n |= n >> shift
		shift <<= 1
	}
	return n + 1
}

// Fatal error mocking, to be able to test an expected fatal

#if DEBUG
var expectedFatal = false
@noreturn func fatalError(@autoclosure message: () -> String = "", file: StaticString = #file, line: UInt = #line) {
	if expectedFatal { NSThread.exit() }
	Swift.fatalError(message, file: file, line: line)
}
#endif