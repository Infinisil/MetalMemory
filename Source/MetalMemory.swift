//
//  MetalMemory.swift
//  MetalMemory
//
//  Created by Silvan Mosberger on 23/05/16.
//  
//

import Metal

/// Protocol for any type that provides a `MTLBuffer` and an offset, enabling the usage of it with the Metal API
public protocol MetalMemory {
	var buffer : MTLBuffer { get }
	var offset : Int { get }
}
