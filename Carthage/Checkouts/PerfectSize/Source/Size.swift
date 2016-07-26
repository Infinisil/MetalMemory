//
//  PerfectSize.swift
//  PerfectSize
//
//  Created by Silvan Mosberger on 25/07/16.
//  
//

public protocol Size : CustomStringConvertible {
	/// Initialize this struct with every byte set to the given one
	init(byte: UInt8)
}

/// A struct with a size of the base struct plus one byte.
public struct Plus1<S : Size> : Size {
	let s : S
	let x : UInt8
	
	/// Initialize this struct with every byte set to the given one
	public init(byte: UInt8 = 0) {
		s = S(byte: byte)
		x = byte
	}
}

extension Size {
	/// Convenience typealias for adding 1 byte to any size struct.
	///
	/// - Note: You can no further encode digits after using this typealias.
	public typealias Add1 = Plus1<Self>
	
	public var description: String {
		return "[size: \(sizeof(Self))]"
	}
}