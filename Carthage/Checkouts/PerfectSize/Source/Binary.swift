//
//  Binary.swift
//  PerfectSize
//
//  Created by Silvan Mosberger on 25/07/16.
//  
//

public protocol BinarySize : Size {}

/**
The base struct for building a struct of a certain binary size. Continously use the typealiases `O` and `I` to encode a number.

**Examples**:
```
typealias FourtyTwo = B.I.0.I.0.I.0
typealias TwoHundredFiftySix = B.I.O.O.O.O.O.O.O.O
```
*/
public struct B : BinarySize {
	/// Initialize this struct with every byte set to the given one
	public init(byte: UInt8 = 0) {}
}

/// A struct with a size of the base struct times two.
public struct Times2<S : BinarySize> : BinarySize {
	let a, b : S
	
	/// Initialize this struct with every byte set to the given one
	public init(byte: UInt8 = 0) {
		a = S(byte: byte)
		b = a
	}
}

/// A struct with a size of the base struct plus one byte.
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
	/// Add the bit `0` to the resulting size of the type. This essentially multiplies the size by 2.
	typealias O = Times2<Self>
	/// Add the bit `1` to the resulting size of the type. This essentially multiplies the size by 2 and adds 1.
	typealias I = BinaryPlus1<O>
}