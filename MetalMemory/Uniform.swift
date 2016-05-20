//
//  Uniform.swift
//  MetalExperiments
//
//  Created by Silvan Mosberger on 05/04/16.
//  Copyright © 2016 Silvan Mosberger. All rights reserved.
//

import Foundation
import Metal

public class Uniform<T> {
	private let size : Int
	private let pointer : UnsafeMutablePointer<T>
	public let metalBuffer : MTLBuffer
	
	public var label : String? {
		didSet {
			metalBuffer.label = label
		}
	}
	
	public var memory : T {
		get {
			return pointer.memory
		}
		set {
			pointer.memory = newValue
		}
	}
	
	public init(value: T, device: MTLDevice, label: String? = nil) {
		self.label = label
		size = NSRoundUpToMultipleOfPageSize(sizeof(T))
		
		pointer = UnsafeMutablePointer(NSAllocateMemoryPages(size))
		pointer.memory = value
		
		metalBuffer = device.newBufferWithBytesNoCopy(pointer,
		                                              length: size,
		                                              options: .CPUCacheModeDefaultCache,
		                                              deallocator: nil)
		metalBuffer.label = label
	}
	
	deinit {
		NSDeallocateMemoryPages(pointer, size)
	}
}