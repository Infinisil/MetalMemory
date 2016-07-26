//
//  Add.swift
//  PerfectSize
//
//  Created by Silvan Mosberger on 27/07/16.
//  
//

/// A struct with a size of the added sizes of the type parameters
public struct Add<A : Size, B : Size> : Size {
	let a : A
	let b : B
	
	/// Initialize with already existing values for `A` and `B`. Same as the `+` operator.
	public init(a: A, b: B) {
		self.a = a
		self.b = b
	}
	
	/// Initialize this struct with every byte set to the given one
	public init(byte: UInt8 = 0) {
		a = A(byte: byte)
		b = B(byte: byte)
	}
}

/// Adds the sizes of the types together to get a new type of the combined size.
///
/// - Note: Does not work with `typealias`.
///
/// **Example**:
///
///     let twenty = (B.I.O.O.O.self + D.n1.n2.self).init()
public func +<A: Size, B: Size>(a: A.Type, b: B.Type) -> Add<A, B>.Type {
	return Add.self
}

/**
Concatenates the bytes of the two types to create a new instance of a type that has the combined size.

**Example**:
 
	// Creates a type with size 0b111 + 7 = 14
	let combination = B.I.I.I() + D.n7()
*/
public func +<A: Size, B: Size>(a: A, b: B) -> Add<A, B> {
	return Add(a: a, b: b)
}