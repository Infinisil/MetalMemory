//
//  Uniform.swift
//  MetalExperiments
//
//  Created by Silvan Mosberger on 05/04/16.
//  Copyright © 2016 Silvan Mosberger. All rights reserved.
//

import Metal

private let resourceOptions : MTLResourceOptions = [.StorageModeShared, .CPUCacheModeDefaultCache]

/**
Acts as a cheap view onto a MTLBuffer as a single item of type T.

This class encapsulates the allocation (and deallocation) of the necessary memory to store a single value of type T. If the device (MTLDevice) is set or updated, a MTLBuffer is created on that device using the memory used to store the value of type T. Note that upon updating the device, no memory is moved, only the buffer is updated. This means that the memory used to store the value exists as long as the instance of this class isn't deallocated.

The `MTLResourceOptions` used to create the `MTLBuffer` are `.StorageModeShared` and `.CPUCacheModeDefaultCache`. The `offset` property will always return `0`. Note that the amount of allocated bytes is `sizeof(T)` rounded up to the next page-multiple. If no value is given initially, the memory is initialized to all zeros. Setting and getting calls to the `value` property have no overhead, since it's just using the direct pointer to the memory and inlining the call.


Example usage:

```swift
let int = Uniform(value: 10)
int.device = metalDevice
int.value += 1
commandEncoder.setMemory(int, atIndex: 0)
```
*/
public final class Uniform<T> : MetalMemory {
	
	/// The `MTLdevice` to use for creating the buffer.
	/// Initially this property is nil. Upon setting this property, a new `MTLBuffer` is created on the new device using the already existing memory where the value is stored. The label of the new buffer is set to the label of this Uniform object.
	public var device : MTLDevice? {
		get {
			return _metalBuffer?.device
		}
		set {
			_metalBuffer = newValue?.newBufferWithBytesNoCopy(pointer, length: constMemory.bytes, options: resourceOptions, deallocator: nil)
			_metalBuffer?.label = label
		}
	}
	
	
	/// The buffer, representing the memory of this Uniform object.
	/// If the `device` property was set to some value, this property will return a `MTLBuffer` containing the memory of this Uniform, otherwise fatal error.
	public var buffer : MTLBuffer {
		if let buffer = _metalBuffer {
			return buffer
		} else {
			fatalError("MTLDevice not provided and therefore no MTLBuffer available. Set the `device` property to prevent this.")
		}
	}
	
	/// The offset within the buffer memory. This will always be zero.
	public var offset : Int { return 0 }
	
	/// Used to store the actual buffer (if `device` is set)
	private var _metalBuffer : MTLBuffer?
	
	/// The actual memory
	private let constMemory : ConstPageMemory
	
	/// The pointer to the start of the memory, equivalent to `constMemory.pointer`
	private var pointer : UnsafeMutablePointer<T>
	
	
	/// A label for giving this Uniform a meaningful name for debugging purposes. The `buffer` property will have the same label.
	public var label : String? {
		didSet {
			_metalBuffer?.label = label
		}
	}
	

	/// Create a new Uniform with no device set and memory initialized to zero.
	public init() {
		constMemory = ConstPageMemory(bytes: sizeof(T))
		pointer = UnsafeMutablePointer(constMemory.pointer)
	}
	
	/// Create a new Uniform with no device set and memory initialized to `value`.
	public convenience init(value: T) {
		self.init()
		self.value = value
	}
	
	/// Create a new Uniform with the device set and memory initialized to zero.
	public convenience init(device: MTLDevice) {
		self.init()
		self.device = device
	}
	
	/// Create a new Uniform with the device set and memory initialized to `value`
	public convenience init(value: T, device: MTLDevice) {
		self.init(value: value)
		self.device = device
	}
	
	
	/// The value of the memory. Calls to this getter/setter are always inlined and have therefore no performance overhead.
	public var value : T {
		@inline(__always) get {
			return pointer.memory
		}
		@inline(__always) set {
			pointer.memory = newValue
		}
	}
}

extension Uniform : CustomStringConvertible, CustomDebugStringConvertible {
	public var description: String {
		return "\(value)"
	}
	
	public var debugDescription: String {
		return "{value: \(value), label: \"\(label)\", device: \(device), buffer: \(_metalBuffer)}"
	}
}