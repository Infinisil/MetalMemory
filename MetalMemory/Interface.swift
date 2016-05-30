//
//  Ext.swift
//  MetalMemory
//
//  Created by Silvan Mosberger on 23/05/16.
//  
//

import Metal

public extension MTLRenderCommandEncoder {
	@inline(__always)
	func setVertexMemory(memory: MetalMemory, atIndex index: Int) {
		setVertexBuffer(memory.buffer, offset: memory.offset, atIndex: index)
	}
	
	@inline(__always)
	func setFragmentMemory(memory: MetalMemory, atIndex index: Int) {
		setFragmentBuffer(memory.buffer, offset: memory.offset, atIndex: index)
	}
}