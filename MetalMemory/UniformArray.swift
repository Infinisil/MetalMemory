//
//  UniformArray.swift
//  MetalExperiments
//
//  Created by Silvan Mosberger on 08/04/16.
//  Copyright © 2016 Silvan Mosberger. All rights reserved.
//

import Foundation
import Metal

private let pagesize = NSPageSize()

final class UniformArray<T> : CollectionType, CustomStringConvertible {
	private let device : MTLDevice
	private(set) var metalBuffer : MTLBuffer {
		didSet {
			metalBuffer.label = label
		}
	}
	private(set) var memory : PageMemory<T>
	
	var label : String? {
		didSet {
			metalBuffer.label = label
		}
	}
	
	var description: String {
		return "[\(map{"\($0)"}.joinWithSeparator(", "))]"
	}
	
	var allocatedPages = 1 {
		didSet {
			guard oldValue < allocatedPages else { return }
			
			let oldMemory = memory
			memory = PageMemory(pages: allocatedPages)
			NSCopyMemoryPages(oldMemory.pointer, memory.pointer, endIndex * strideof(T))
			
			free += (allocatedPages - oldValue) * pagesize
			
			metalBuffer = device.newBufferWithBytesNoCopy(memory.pointer, length: memory.bytes, options: .CPUCacheModeDefaultCache, deallocator: nil)
		}
	}
	
	var free = pagesize
	
	var startIndex = 0
	var endIndex = 0
	
	init(device: MTLDevice, label: String?) {
		self.device = device
		self.label = label
		memory = PageMemory(pages: allocatedPages)
		metalBuffer = device.newBufferWithBytesNoCopy(memory.pointer, length: memory.bytes, options: .CPUCacheModeDefaultCache, deallocator: nil)
		metalBuffer.label = label
	}
	
	convenience init() {
		self.init(device: MTLCreateSystemDefaultDevice()!)
	}
	
	convenience init(device: MTLDevice) {
		self.init(device: device, label: nil)
	}
	
	func generate() -> UnsafeBufferPointerGenerator<T> {
		return memory.bufferPointer.generate()
	}
	
	subscript (position : Int) -> T {
		get {
			return memory.pointer[position]
		}
		set {
			memory.pointer[position] = newValue
		}
	}
	
	func replace<C : CollectionType where C.Generator.Element == T>(with c: C) {
		replaceRange(indices, with: c)
	}
	
	func replaceWithData(data: NSData) {
		let newCount = data.length / strideof(T)
		reserveCapacity(newCount)
		memcpy(memory.pointer, data.bytes, data.length)
		endIndex = newCount
		free = memory.bytes - data.length
	}
	
	func extendTo(n: Int) {
		reserveCapacity(n)
		endIndex = n
		free = memory.bytes - strideof(T) * n
	}
}


extension UniformArray : RangeReplaceableCollectionType {
	func reserveCapacity(n: Int) {
		allocatedPages = NSRoundUpToMultipleOfPageSize(n * strideof(T)) / pagesize
	}
	
	func append(newElement: T) {
		if free < strideof(T) {
			allocatedPages += 1
		}
		
		memory.pointer[endIndex] = newElement
		endIndex += 1
		free -= strideof(T)
	}
	
	func replaceRange<C : CollectionType where C.Generator.Element == T>(subRange: Range<Int>, with newElements: C) {
		let ccount = Int(newElements.count.toIntMax())
		let dif = ccount - subRange.count
		
		if free < dif * strideof(T) {
			reserveCapacity(count - subRange.count + ccount)
		}
		
		if subRange.endIndex != endIndex {
			let dest = memory.pointer.advancedBy(subRange.startIndex).advancedBy(ccount)
			let orig = memory.pointer.advancedBy(subRange.endIndex)
			let n = dest.distanceTo(memory.pointer.advancedBy(endIndex)) * strideof(T)
			
			memmove(dest, orig, n)
		}
		
		var index = subRange.startIndex
		for elem in newElements {
			memory.pointer[index] = elem
			index += 1
		}
		
		endIndex += dif
		free -= dif * strideof(T)
	}
	
	func appendContentsOf<S : CollectionType where S.Generator.Element == T>(newElements: S) {
		replaceRange(endIndex..<endIndex, with: newElements)
	}
}

extension UniformArray {
	convenience init(count: Int, repeatedValue: T) {
		self.init()
		let vals = [T](count: count, repeatedValue: repeatedValue)
		appendContentsOf(vals)
	}
}

