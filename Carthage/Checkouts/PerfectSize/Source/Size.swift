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

extension Size {
	public var description: String {
		return "[size: \(sizeof(Self))]"
	}
}