//
//  Utils.swift
//  MetalMemory
//
//  Created by Silvan Mosberger on 20/05/16.
//  
//

import Foundation


func flp2(n: UInt) -> UInt {
	var n = n
	n = n | (n >> 1)
	n = n | (n >> 2)
	n = n | (n >> 4)
	n = n | (n >> 8)
	n = n | (n >> 16)
	n = n | (n >> 32)
	return n - (n >> 1)
}




// Fatal error mocking, to be able to test an expected fatal

var expectedFatal = false
@noreturn func fatalError(@autoclosure message: () -> String = "", file: StaticString = #file, line: UInt = #line) {
	if expectedFatal {
		NSThread.exit()
	}
	Swift.fatalError(message, file: file, line: line)
}