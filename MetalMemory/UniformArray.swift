//
//  PageMemory.swift
//  MetalMemory
//
//  Created by Silvan Mosberger on 20/05/16.
//
//

import Metal


private let resourceOptions : MTLResourceOptions = [.StorageModeShared, .CPUCacheModeDefaultCache]
private let defaultAllocationPolicy = Policy(size: .PowerOfTwo, decrease: true)

final public class UniformArray<T> : MetalMemory {
	var memory : PageMemory
	
	private let policy : Policy
	
	public var device : MTLDevice? {
		didSet {
			update(memory.mem.pointer, bytes: memory.mem.bytes)
		}
	}
	
	private func update(pointer: UnsafeMutablePointer<Void>, bytes: Int) {
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
			memory.bytes = UniformArray.getBytesNeeded(count)
		}
	}
	
	static func getBytesNeeded(count: Int) -> Int {
		return max(1, count) * strideof(T)
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
		self.init(count: 0)
	}
	
	public func reserveCapacity(n: Int) {
		memory.bytes = max(memory.bytes, n * strideof(T))
	}
	
	private var free : Int {
		return (memory.bytes - count * strideof(T)) / strideof(T)
	}
	
	public func append(newElement: T) {
		count += 1
		self[endIndex - 1] = newElement
	}
	
	public func replaceRange<C : CollectionType where C.Generator.Element == T>(subRange: Range<Int>, with newElements: C) {
		let ccount = Int(newElements.count.toIntMax())
		let dif = ccount - subRange.count
		
		// Reserve enough memory if needed
		if free < dif { // Is this needed?
			reserveCapacity(count + dif)
		}
		
		// Optionally move memory behind the replacement
		if subRange.endIndex != count {
			let dest = pointer.advancedBy(subRange.startIndex).advancedBy(ccount)
			let orig = pointer.advancedBy(subRange.endIndex)
			let n = dest.distanceTo(pointer.advancedBy(count)) * strideof(T)
			
			memmove(dest, orig, n)
		}
		
		// Copy new elements from given collection
		var index = subRange.startIndex
		for elem in newElements {
			pointer[index] = elem
			index += 1
		}
		
		count += dif
	}
	
	public func appendContentsOf<S : CollectionType where S.Generator.Element == T>(newElements: S) {
		replaceRange(endIndex..<endIndex, with: newElements)
	}
}

public extension UniformArray {
	convenience init(count: Int, repeatedValue: T) {
		self.init()
		self.count = count
		memory.bytes = count * strideof(T)
		for i in indices {
			self[i] = repeatedValue
		}
	}
}
