//
//  PageMemory.swift
//  MetalMemory
//
//  Created by Silvan Mosberger on 20/05/16.
//
//

import Foundation

final class PageMemory<T> {
	let bytes : Int
	let pointer : UnsafeMutablePointer<T>
	let bufferPointer : UnsafeMutableBufferPointer<T>
	
	init(pages: Int) {
		bytes = pages * NSPageSize()
		
		pointer = UnsafeMutablePointer(NSAllocateMemoryPages(bytes))
		bufferPointer = UnsafeMutableBufferPointer(start: pointer, count: bytes / strideof(T))
	}
	
	deinit {
		NSDeallocateMemoryPages(pointer, bytes)
	}
}