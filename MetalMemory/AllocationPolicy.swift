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
	enum Rounding {
		
		/// Multiple of page-size, recommended on small amounts of memory
		case PageMultiple
		
		/// Powers of 2, recommended on big amounts of memory, or memory that's changing a lot
		case PowerOfTwo
		
		/// Returns the amount of bytes needed for this Rounding policy. The result is a multiple of page-size
		func bytesNeeded(minBytes: Int) -> Int {
			let pageBytes = NSRoundUpToMultipleOfPageSize(minBytes)
			switch self {
			case .PageMultiple: return pageBytes
			case .PowerOfTwo: return Int(flp2(UInt(pageBytes)))
			}
		}
	}
	
	/// A policy for rounding
	let rounding: Rounding
	
	/// A policy for deallocating
	let decrease : Bool
	
	init(size: Rounding = .PageMultiple, decrease: Bool = true) {
		self.rounding = size
		self.decrease = decrease
	}
	
	/// Returns the amount of bytes needed according to this policy
	func bytesNeeded(oldBytes old: Int, newBytes: Int) -> Int {
		return max(decrease ? 0 : old, rounding.bytesNeeded(newBytes))
	}
}

