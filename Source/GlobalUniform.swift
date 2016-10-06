//
//  GlobalUniform.swift
//  MetalMemory
//
//  Created by Silvan Mosberger on 22/05/16.
//  
//

import Metal

private var globalBuffer : MTLBuffer?
public var globalUniformDevice : MTLDevice? {
didSet {
	updateBuffer(globalMemory.mem.pointer, bytes: globalMemory.mem.bytes)
}
}

private func updateBuffer(_ pointer: UnsafeMutableRawPointer, bytes: Int) {
	globalBuffer = globalUniformDevice?.makeBuffer(bytesNoCopy: pointer, length: bytes, options: MTLResourceOptions(), deallocator: nil)
	globalBuffer?.label = "globalBuffer"
}

private let globalMemory = PageMemory(bytes: 0, policy: Policy(rounding: .pageMultiple, decrease: false), movedCallbacks: [updateBuffer])
private var globalOffset : Int = 0



/**
Acts as a cheap view onto a `MTLBuffer`. The same `MTLBuffer` object is used for all instances of this class, minimizing the number of `MTLBuffer` objects and memory allocated. The disadvantage is that it's not possible to use multiple, different devices with this class.

This class encapsulates the allocation (and deallocation) of the necessary memory to store a single value of type T. If the device (MTLDevice) is set or updated, a MTLBuffer is created on that device using the memory used to store the value of type T. Note that upon updating the device, no memory is moved, only the buffer is updated.

The `MTLResourceOptions` used to create the `MTLBuffer` are `.StorageModeShared` and `.CPUCacheModeDefaultCache`. If no value is given initially, the memory is initialized to all zeros. Setting and getting calls to the `value` property have no overhead, since it's just using the direct pointer to the memory and inlining the call.


Example usage:

```swift
let int = GlobalUniform(value: 10)
globalUniformDevice = metalDevice
int.value += 1
commandEncoder.setMemory(int, atIndex: 0)
```
*/
public final class GlobalUniform<T> : MetalMemory, CustomStringConvertible {
	public var buffer: MTLBuffer {
		if let buffer = globalBuffer {
			return buffer
		} else {
			fatalError("MTLDevice not provided and therefore no MTLBuffer available. Set the `globalUniformDevice` global variable to prevent this.")
		}
	}
	
	public let offset : Int
	
	public var description : String {
		return "\(value)"
	}
	
	public init() {
		globalMemory.bytes += MemoryLayout<T>.size
		offset = globalOffset
		globalOffset += MemoryLayout<T>.size
		pointer = globalMemory.mem.pointer.advanced(by: offset).bindMemory(to: T.self, capacity: 1)
		
		globalMemory.movedCallbacks.append { [weak self] pointer, bytes in
			if let s = self {
				s.pointer = globalMemory.mem.pointer.advanced(by: s.offset).bindMemory(to: T.self, capacity: 1)
			}
		}
	}
	
	public convenience init(value: T) {
		self.init()
		self.value = value
	}
	
	fileprivate var pointer : UnsafeMutablePointer<T>
	
	public var value : T {
		@inline(__always) get {
			return pointer.pointee
		}
		@inline(__always) set {
			pointer.pointee = newValue
		}
	}
}



