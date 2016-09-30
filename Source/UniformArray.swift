//
//  PageMemory.swift
//  MetalMemory
//
//  Created by Silvan Mosberger on 20/05/16.
//
//

import Metal


private let resourceOptions : MTLResourceOptions = MTLResourceOptions()
private let defaultAllocationPolicy = Policy(rounding: .powerOfTwo, decrease: true)

final public class UniformArray<T> : MetalMemory {
	var memory : PageMemory
	
	fileprivate let policy : Policy
	
	public var device : MTLDevice? {
		didSet {
			update(memory.mem.pointer, bytes: memory.mem.bytes)
		}
	}
	
	fileprivate func update(_ pointer: UnsafeMutableRawPointer, bytes: Int) {
		_metalBuffer = device?.makeBuffer(bytesNoCopy: pointer, length: bytes, options: resourceOptions, deallocator: nil)
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
	
	fileprivate var _metalBuffer : MTLBuffer?
	
	var pointer : UnsafeMutablePointer<T> {
		return memory.mem.pointer.bindMemory(to: T.self, capacity: count)
	}
	
	var bufferPointer : UnsafeMutableBufferPointer<T> {
		return UnsafeMutableBufferPointer(start: pointer, count: count)
	}
	
	public var count : Int {
		didSet {
			memory.bytes = UniformArray.getBytesNeeded(count)
		}
	}
	
	static func getBytesNeeded(_ count: Int) -> Int {
		return Swift.max(1, count) * MemoryLayout<T>.stride
	}
	
	public init(count: Int, policy: Policy = defaultAllocationPolicy) {
		self.policy = policy
		self.count = count
		memory = PageMemory(bytes: UniformArray.getBytesNeeded(count), policy: policy)
		memory.movedCallbacks.append(update)
	}
	
	public convenience init(policy: Policy) {
		self.init(count: 0, policy: policy)
	}
}

extension UniformArray : Collection {
	public func index(after i: Int) -> Int {
		return i + 1
	}

	public var startIndex : Int { return 0 }
	public var endIndex : Int { return count }
	
	public func makeIterator() -> UnsafeBufferPointerIterator<T> {
		return bufferPointer.makeIterator()
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

extension UniformArray : RangeReplaceableCollection {
	
	convenience public init() {
		self.init(count: 0)
	}
	
	public func reserveCapacity(_ n: Int) {
		memory.bytes = Swift.max(memory.bytes, n * MemoryLayout<T>.stride)
	}
	
	fileprivate var free : Int {
		return (memory.bytes - count * MemoryLayout<T>.stride) / MemoryLayout<T>.stride
	}
	
	public func append(_ newElement: T) {
		count += 1
		self[endIndex - 1] = newElement
	}
	
	public func replaceSubrange<C : Collection>(_ subRange: Range<Int>, with newElements: C) where C.Iterator.Element == T {
		let ccount = Int(newElements.count.toIntMax())
		let dif = ccount - subRange.count
		
		// Reserve enough memory if needed
		if free < dif { // Is this needed?
			reserveCapacity(count + dif)
		}
		
		// Optionally move memory behind the replacement
		if subRange.upperBound != count {
			let dest = pointer.advanced(by: subRange.lowerBound).advanced(by: ccount)
			let orig = pointer.advanced(by: subRange.upperBound)
			let n = dest.distance(to: pointer.advanced(by: count)) * MemoryLayout<T>.stride
			
			memmove(dest, orig, n)
		}
		
		// Copy new elements from given collection
		var index = subRange.lowerBound
		for elem in newElements {
			pointer[index] = elem
			index += 1
		}
		
		count += dif
	}
	
	public func appendContentsOf<S : Collection>(_ newElements: S) where S.Iterator.Element == T {
		replaceSubrange(endIndex..<endIndex, with: newElements)
	}
}

public extension UniformArray {
	convenience init(count: Int, repeatedValue: T) {
		self.init()
		self.count = count
		memory.bytes = count * MemoryLayout<T>.stride
		for i in indices {
			self[i] = repeatedValue
		}
	}
}
