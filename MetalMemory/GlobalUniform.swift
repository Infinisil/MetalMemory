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

private func updateBuffer(pointer: UnsafeMutablePointer<Void>, bytes: Int) {
	globalBuffer = globalUniformDevice?.newBufferWithBytesNoCopy(pointer, length: bytes, options: [.CPUCacheModeDefaultCache, .StorageModeShared], deallocator: nil)
	globalBuffer?.label = "globalBuffer"
}

private let globalMemory = PageMemory(bytes: 0, policy: Policy(size: .PageMultiple, decrease: false), movedCallbacks: updateBuffer)
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
commandEncoder.setBuffer(int.buffer, offset: int.offset, atIndex: 0)
```
*/
public final class GlobalUniform<T> : MetalMemory, CustomStringConvertible {
	public var buffer: MTLBuffer {
		if let buffer = globalBuffer {
			return buffer
		} else {
			fatalError("Device not set")
		}
	}
	
	public let offset : Int
	
	public var description : String {
		return "\(memory)"
	}
	
	public init() {
		globalMemory.bytes += sizeof(T)
		offset = globalOffset
		globalOffset += sizeof(T)
		pointer = UnsafeMutablePointer(globalMemory.mem.pointer.advancedBy(offset))
		
		globalMemory.movedCallbacks.append { [weak self] pointer, bytes in
			if let s = self {
				s.pointer = UnsafeMutablePointer(globalMemory.mem.pointer.advancedBy(s.offset))
			}
		}
	}
	
	public convenience init(value: T) {
		self.init()
		memory = value
	}
	
	private var pointer : UnsafeMutablePointer<T>
	
	public var memory : T {
		@inline(__always) get {
			return pointer.memory
		}
		@inline(__always) set {
			pointer.memory = newValue
		}
	}
}



