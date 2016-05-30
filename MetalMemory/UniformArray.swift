//
//  PageMemory.swift
//  MetalMemory
//
//  Created by Silvan Mosberger on 20/05/16.
//
//

import Foundation
import Metal


private let resourceOptions : MTLResourceOptions = [.StorageModeShared, .CPUCacheModeDefaultCache]


final public class UniformArray<T> : MetalMemory {
	private var memory : PageMemory
	
	private let policy : Policy
	
	public var device : MTLDevice? {
		get {
			return _metalBuffer?.device
		}
		set {
			update(memory.mem.pointer, bytes: memory.mem.bytes)
		}
	}
	
	func update(pointer: UnsafeMutablePointer<Void>, bytes: Int) {
		_metalBuffer = device?.newBufferWithBytesNoCopy(pointer, length: bytes, options: resourceOptions, deallocator: nil)
		_metalBuffer?.label = label
	}
	
	public var buffer : MTLBuffer {
		if let buffer = _metalBuffer {
			return buffer
		} else {
			fatalError("MTLDevice not provided and therefore no MTLBuffer available. Set the `device` property to prevent this.")
		}
	}
	
	public var label : String? {
		didSet {
			_metalBuffer?.label = label
		}
	}
	
	public var offset : Int { return 0 }
	
	private var _metalBuffer : MTLBuffer?
	
	var pointer : UnsafeMutablePointer<T> {
		return UnsafeMutablePointer(memory.mem.pointer)
	}
	
	var bufferPointer : UnsafeMutableBufferPointer<T> {
		return UnsafeMutableBufferPointer(start: pointer, count: count)
	}
	
	public var count : Int {
		didSet {
			memory.bytes = count * strideof(T)
		}
	}
	
	public init(count: Int, policy: Policy = Policy()) {
		self.policy = policy
		self.count = count
		memory = PageMemory(bytes: count * strideof(T), policy: Policy())
		memory.movedCallbacks.append(update)
	}
}

extension UniformArray : CollectionType {
	public var startIndex : Int { return 0 }
	public var endIndex : Int { return count }
	
	public func generate() -> UnsafeBufferPointerGenerator<T> {
		return bufferPointer.generate()
	}
	
	public subscript (position : Int) -> T {
		get {
			return pointer[position]
		}
		set {
			pointer[position] = newValue
		}
	}
}

extension UniformArray : RangeReplaceableCollectionType {
	
	convenience public init() {
		self.init(count: 1)
	}
	
	public func reserveCapacity(n: Int) {
		count = max(count, n)
	}
	
	private var free : Int {
		return (memory.bytes - count * strideof(T)) / strideof(T)
	}
	
	public func replaceRange<C : CollectionType where C.Generator.Element == T>(subRange: Range<Int>, with newElements: C) {
		let ccount = Int(newElements.count.toIntMax())
		let dif = ccount - subRange.count
		
		if free < dif {
			reserveCapacity(count + dif)
		}
		
		if subRange.endIndex != count {
			let dest = pointer.advancedBy(subRange.startIndex).advancedBy(ccount)
			let orig = pointer.advancedBy(subRange.endIndex)
			let n = dest.distanceTo(pointer.advancedBy(count)) * strideof(T)
			
			memmove(dest, orig, n)
		}
		
		var index = subRange.startIndex
		for elem in newElements {
			pointer[index] = elem
			index += 1
		}
		
		count += dif
	}
}
