//
//  Decimal.swift
//  PerfectSize
//
//  Created by Silvan Mosberger on 25/07/16.
//  
//


public protocol DecimalSize : Size {}

public struct D : DecimalSize {
	/// Initialize this struct with every byte set to the given one
	public init(byte: UInt8 = 0) {}
}

public struct DecimalPlus1<S : DecimalSize> : DecimalSize {
	let a : S
	let x : UInt8
	
	/// Initialize this struct with every byte set to the given one
	public init(byte: UInt8 = 0) {
		a = S(byte: byte)
		x = byte
	}
}

public struct Times10<S : Size> : DecimalSize {
	let a0, a1, a2, a3, a4, a5, a6, a7, a8, a9 : S
	
	/// Initialize this struct with every byte set to the given one
	public init(byte: UInt8 = 0) {
		a0 = S(byte: byte)
		a1 = a0
		a2 = a0
		a3 = a0
		a4 = a0
		a5 = a0
		a6 = a0
		a7 = a0
		a8 = a0
		a9 = a0
	}
}

public extension DecimalSize {
	typealias n0 = Times10<Self>
	typealias n1 = DecimalPlus1<n0>
	typealias n2 = DecimalPlus1<n1>
	typealias n3 = DecimalPlus1<n2>
	typealias n4 = DecimalPlus1<n3>
	typealias n5 = DecimalPlus1<n4>
	typealias n6 = DecimalPlus1<n5>
	typealias n7 = DecimalPlus1<n6>
	typealias n8 = DecimalPlus1<n7>
	typealias n9 = DecimalPlus1<n8>
}