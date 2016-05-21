//
//  Uniform.swift
//  MetalExperiments
//
//  Created by Silvan Mosberger on 05/04/16.
//  Copyright © 2016 Silvan Mosberger. All rights reserved.
//

import Foundation
import Metal

private let resourceOptions : MTLResourceOptions = [.StorageModeShared, .CPUCacheModeDefaultCache]

/// Acts as a cheap view onto a MTLBuffer as a single item of type T
public final class Uniform<T> : CustomStringConvertible, CustomDebugStringConvertible {
	
	public var device : MTLDevice? {
		get {
			return _metalBuffer?.device
		}
		set {
			_metalBuffer = newValue?.newBufferWithBytesNoCopy(pointer, length: size, options: resourceOptions, deallocator: nil)
			_metalBuffer?.label = label
		}
	}
	
	public var metalBuffer : MTLBuffer {
		if let buffer = _metalBuffer {
			return buffer
		} else {
			fatalError("MTLDevice not provided and therefore no MTLBuffer available. Set the `device` property to prevent this.")
		}
	}
	
	private var _metalBuffer : MTLBuffer?
	private let pointer : UnsafeMutablePointer<T>

	private let size = NSRoundUpToMultipleOfPageSize(sizeof(T))
	
	public var label : String? {
		didSet {
			_metalBuffer?.label = label
		}
	}
	
	public var description: String {
		return "\(memory)"
	}
	
	public var debugDescription: String {
		return "{memory: \(memory), label: \"\(label)\", device: \(device), pointer: \(pointer), buffer: \(_metalBuffer)}"
	}
	
	public init() {
		guard size > 0 else { fatalError("Uniform type has to have sizeof > 0") }
		pointer = UnsafeMutablePointer(NSAllocateMemoryPages(size))
	}
	
	public convenience init(value: T) {
		self.init()
		memory = value
	}
	
	public convenience init(device: MTLDevice) {
		self.init()
		self.device = device
	}
	
	public convenience init(value: T, device: MTLDevice) {
		self.init(value: value)
		self.device = device
	}
	
	public var memory : T {
		@inline(__always) get {
			return pointer.memory
		}
		@inline(__always) set {
			pointer.memory = newValue
		}
	}
	
	deinit {
		NSDeallocateMemoryPages(pointer, size)
	}
}