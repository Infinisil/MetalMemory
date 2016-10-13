//
//  PageMemory.swift
//  MetalMemory
//
//  Created by Silvan Mosberger on 23/05/16.
//  
//

import Foundation

/**
	Manages the basic allocation/deallocation of page aligned memory
*/
final class ConstPageMemory {
	let pointer : UnsafeMutableRawPointer
	let bytes : Int
	
	init(bytes: Int) {
		self.bytes = NSRoundUpToMultipleOfPageSize(bytes)
		pointer = NSAllocateMemoryPages(bytes)
	}
	
	deinit {
		NSDeallocateMemoryPages(pointer, bytes)
	}
}


/**
	Manages variable sized page-aligned memory. Upon size change it may allocate new memory (depending on the policy) and when it does, the old contents get copied over and the `movedCallback` is called with the new pointer and size in bytes.
*/
final class PageMemory {
	typealias MovedCallback = (_ pointer: UnsafeMutableRawPointer, _ bytes: Int) -> Void
	
	var policy : Policy
	
	/// Callbacks to invoke when the memory has moved
	var movedCallbacks : [MovedCallback] = []
	
	// The underlying memory. This property changes everytime the memory gets de/increased.
	var mem : ConstPageMemory {
		didSet {
			NSCopyMemoryPages(oldValue.pointer, mem.pointer, min(oldValue.bytes, mem.bytes))
			movedCallbacks.forEach { $0(mem.pointer, mem.bytes) }
			log.debug{ [old = oldValue.bytes, new = mem.bytes] in
				"Allocated more memory and copied previous memory into it. Previous bytes: \(old), new bytes: \(new)"}
		}
	}
	
	/// The minimum amout of bytes that should be allocated, the actual amount is calculated using the policy
	var bytes : Int {
		didSet {
			let actual = policy.bytesNeeded(oldBytes: oldValue, newBytes: bytes)
			if actual != mem.bytes {
				mem = ConstPageMemory(bytes: actual)
			}
		}
	}
	
	init(bytes: Int, policy: Policy, movedCallbacks: [MovedCallback] = []) {
		self.movedCallbacks = movedCallbacks
		self.policy = policy
		self.bytes = bytes
		let bytesNeeded = policy.bytesNeeded(oldBytes: 0, newBytes: bytes)
		mem = ConstPageMemory(bytes: bytesNeeded)
	}
}
