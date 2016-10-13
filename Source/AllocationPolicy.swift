//
//  AllocationPolicy.swift
//  MetalMemory
//
//  Created by Silvan Mosberger on 23/05/16.
//  
//

import Foundation


/// A policy for allocating/deallocating memory.
public struct Policy {
	public enum Rounding {
		
		/// Multiple of page-size, recommended on small amounts of memory
		case pageMultiple
		
		/// Powers of 2, recommended on big amounts of memory, or memory that's changing a lot
		case powerOfTwo
		
		/// Returns the amount of bytes needed for this Rounding policy. The result is a multiple of page-size
		func bytesNeeded(_ minBytes: Int) -> Int {
			let pageBytes = NSRoundUpToMultipleOfPageSize(minBytes)
			switch self {
			case .pageMultiple: return pageBytes
			case .powerOfTwo: return pageBytes.nextPowerOf2()
			}
		}
	}
	
	/// A policy for rounding
	public let rounding: Rounding
	
	/// A policy for deallocating
	public let decrease : Bool
	
	public init(rounding: Rounding, decrease: Bool) {
		self.rounding = rounding
		self.decrease = decrease
	}
	
	/// Returns the amount of bytes needed according to this policy
	func bytesNeeded(oldBytes old: Int, newBytes: Int) -> Int {
		let unrounded = max(decrease ? 0 : old, newBytes)
		return rounding.bytesNeeded(unrounded)
	}
}

