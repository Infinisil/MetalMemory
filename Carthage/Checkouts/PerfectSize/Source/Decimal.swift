//
//  Decimal.swift
//  PerfectSize
//
//  Created by Silvan Mosberger on 25/07/16.
//  
//


public protocol DecimalSize : Size {}

/**
The base struct for building a struct of a certain decimal size. Continously use the typealiases `n[0-9]` to encode a number.

**Examples**:
```
typealias FourtyTwo = D.n4.n2
typealias Hundred = D.n1.n0.n0
```
*/
public struct D : DecimalSize {
	/// Initialize this struct with every byte set to the given one
	public init(byte: UInt8 = 0) {}
}

/// A struct with a size of the base struct times ten.
public struct Times10<S : DecimalSize> : DecimalSize {
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

/// A struct with a size of the base struct plus one byte.
public struct DecimalPlus1<S : DecimalSize> : DecimalSize {
	let a : S
	let x : UInt8
	
	/// Initialize this struct with every byte set to the given one
	public init(byte: UInt8 = 0) {
		a = S(byte: byte)
		x = byte
	}
}

public extension DecimalSize {
	/// Add the digit `0` to the resulting size of the type. This essentially multiplies the size by 10.
	typealias n0 = Times10<Self>
	/// Add the digit `1` to the resulting size of the type. This essentially multiplies the size by 10 and adds 1.
	typealias n1 = DecimalPlus1<n0>
	/// Add the digit `2` to the resulting size of the type. This essentially multiplies the size by 10 and adds 2.
	typealias n2 = DecimalPlus1<n1>
	/// Add the digit `3` to the resulting size of the type. This essentially multiplies the size by 10 and adds 3.
	typealias n3 = DecimalPlus1<n2>
	/// Add the digit `4` to the resulting size of the type. This essentially multiplies the size by 10 and adds 4.
	typealias n4 = DecimalPlus1<n3>
	/// Add the digit `5` to the resulting size of the type. This essentially multiplies the size by 10 and adds 5.
	typealias n5 = DecimalPlus1<n4>
	/// Add the digit `6` to the resulting size of the type. This essentially multiplies the size by 10 and adds 6.
	typealias n6 = DecimalPlus1<n5>
	/// Add the digit `7` to the resulting size of the type. This essentially multiplies the size by 10 and adds 7.
	typealias n7 = DecimalPlus1<n6>
	/// Add the digit `8` to the resulting size of the type. This essentially multiplies the size by 10 and adds 8.
	typealias n8 = DecimalPlus1<n7>
	/// Add the digit `9` to the resulting size of the type. This essentially multiplies the size by 10 and adds 9.
	typealias n9 = DecimalPlus1<n8>
}