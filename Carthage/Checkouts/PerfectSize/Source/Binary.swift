//
//  Binary.swift
//  PerfectSize
//
//  Created by Silvan Mosberger on 25/07/16.
//  
//

public protocol BinarySize : Size {}

public struct B : BinarySize {
	/// Initialize this struct with every byte set to the given one
	public init(byte: UInt8 = 0) {}
}

public struct Times2<S : BinarySize> : BinarySize {
	let a, b : S
	
	/// Initialize this struct with every byte set to the given one
	public init(byte: UInt8 = 0) {
		a = S(byte: byte)
		b = a
	}
}

public struct BinaryPlus1<S : BinarySize> : BinarySize {	
	let a : S
	let x : UInt8
	
	/// Initialize this struct with every byte set to the given one
	public init(byte: UInt8 = 0) {
		a = S(byte: byte)
		x = byte
	}
}

public extension BinarySize {
	typealias O = Times2<Self>
	typealias I = BinaryPlus1<O>
}