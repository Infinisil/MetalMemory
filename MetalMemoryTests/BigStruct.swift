//
//  BigStruct.swift
//  MetalMemory
//
//  Created by Silvan Mosberger on 21/05/16.
//  
//


typealias S1 = UInt8

struct S2 {
	let v : (S1, S1, S1, S1, S1, S1, S1, S1, S1, S1, S1, S1, S1, S1, S1, S1)
}

struct S3 {
	let v : (S2, S2, S2, S2, S2, S2, S2, S2, S2, S2, S2, S2, S2, S2, S2, S2)
}

struct S4 {
	let v : (S3, S3, S3, S3, S3, S3, S3, S3, S3, S3, S3, S3, S3, S3, S3, S3)
}

struct S5 {
	let v1 : (S4, S4, S4, S4, S4, S4, S4, S4, S4, S4, S4, S4, S4, S4, S4)
	let v2 : (S3, S3, S3, S3, S3, S3, S3, S3, S3, S3, S3, S3, S3, S3, S3)
	let v3 : (S2, S2, S2, S2, S2, S2, S2, S2, S2, S2, S2, S2, S2, S2, S2)
	let v4 : (S1, S1, S1, S1, S1, S1, S1, S1, S1, S1, S1, S1, S1, S1, S1)
}