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
	
	@inline(__always)
	func drawPrimitives(primitiveType: MTLPrimitiveType, indirectMemory: MetalMemory) {
		drawPrimitives(primitiveType, indirectBuffer: indirectMemory.buffer, indirectBufferOffset: indirectMemory.offset)
	}
	
	@inline(__always)
	func drawIndexedPrimitives(primitiveType: MTLPrimitiveType, indexCount: Int, indexType: MTLIndexType, indexMemory: MetalMemory, instanceCount: Int, baseVertex: Int, baseInstance: Int) {
		drawIndexedPrimitives(primitiveType, indexCount: indexCount, indexType: indexType, indexBuffer: indexMemory.buffer, indexBufferOffset: indexMemory.offset, instanceCount: instanceCount, baseVertex: baseVertex, baseInstance: baseInstance)
	}
	
	@inline(__always)
	func drawIndexedPrimitives(primitiveType: MTLPrimitiveType, indexType: MTLIndexType, indexMemory: MetalMemory, indirectMemory: MetalMemory) {
		drawIndexedPrimitives(primitiveType, indexType: indexType, indexBuffer: indexMemory.buffer, indexBufferOffset: indexMemory.offset, indirectBuffer: indirectMemory.buffer, indirectBufferOffset: indirectMemory.offset)
	}
	
	@inline(__always)
	func drawIndexedPrimitives(primitiveType: MTLPrimitiveType, indexCount: Int, indexType: MTLIndexType, indexMemory: MetalMemory) {
		drawIndexedPrimitives(primitiveType, indexCount: indexCount, indexType: indexType, indexBuffer: indexMemory.buffer, indexBufferOffset: indexMemory.offset)
	}

	@inline(__always)
	func drawIndexedPrimitives(primitiveType: MTLPrimitiveType, indexCount: Int, indexType: MTLIndexType, indexMemory: MetalMemory, instanceCount: Int) {
		drawIndexedPrimitives(primitiveType, indexCount: indexCount, indexType: indexType, indexBuffer: indexMemory.buffer, indexBufferOffset: indexMemory.offset, instanceCount: instanceCount)
	}
}

public extension MTLComputeCommandEncoder {
	@inline(__always)
	func setMemory(memory: MetalMemory, atIndex index: Int) {
		setBuffer(memory.buffer, offset: memory.offset, atIndex: index)
	}
	
	@inline(__always)
	func dispatchThreadgroupsWithIndirectMemory(memory: MetalMemory, threadsPerThreadgroup: MTLSize) {
		dispatchThreadgroupsWithIndirectBuffer(memory.buffer, indirectBufferOffset: memory.offset, threadsPerThreadgroup: threadsPerThreadgroup)
	}
}

public extension MTLBlitCommandEncoder {
	@inline(__always)
	func fillMemory(memory : MetalMemory, range: NSRange, value: UInt8) {
		fillBuffer(memory.buffer, range: NSRange(location: range.location + memory.offset, length: range.length), value: value)
	}
	
	@inline(__always)
	func copyFromMemory(sourceMemory: MetalMemory, toMemory: MetalMemory, size: Int) {
		copyFromBuffer(sourceMemory.buffer, sourceOffset: sourceMemory.offset, toBuffer: toMemory.buffer, destinationOffset: toMemory.offset, size: size)
	}
	
	@inline(__always)
	func copyFromMemory(sourceMemory: MetalMemory, sourceBytesPerRow: Int, sourceBytesPerImage: Int, sourceSize: MTLSize, toTexture: MTLTexture, destinationSlice: Int, destinationLevel: Int, destinationOrigin: MTLOrigin) {
		copyFromBuffer(sourceMemory.buffer, sourceOffset: sourceMemory.offset, sourceBytesPerRow: sourceBytesPerRow, sourceBytesPerImage: sourceBytesPerImage, sourceSize: sourceSize, toTexture: toTexture, destinationSlice: destinationSlice, destinationLevel: destinationLevel, destinationOrigin: destinationOrigin)
	}
	
	@inline(__always)
	func copyFromTexture(sourceTexture: MTLTexture, sourceSlice: Int, sourceLevel: Int, sourceOrigin: MTLOrigin, sourceSize: MTLSize, toMemory destinationMemory: MetalMemory, destinationBytesPerRow: Int, destinationBytesPerImage: Int) {
		copyFromTexture(sourceTexture, sourceSlice: sourceSlice, sourceLevel: sourceLevel, sourceOrigin: sourceOrigin, sourceSize: sourceSize, toBuffer: destinationMemory.buffer, destinationOffset: destinationMemory.offset, destinationBytesPerRow: destinationBytesPerRow, destinationBytesPerImage: destinationBytesPerImage)
	}
	
	@inline(__always)
	func copyFromMemory(sourceMemory: MetalMemory, sourceBytesPerRow: Int, sourceBytesPerImage: Int, sourceSize: MTLSize, toTexture destinationTexture: MTLTexture, destinationSlice: Int, destinationLevel: Int, destinationOrigin: MTLOrigin, options: MTLBlitOption) {
		copyFromBuffer(sourceMemory.buffer, sourceOffset: sourceMemory.offset, sourceBytesPerRow: sourceBytesPerRow, sourceBytesPerImage: sourceBytesPerImage, sourceSize: sourceSize, toTexture: destinationTexture, destinationSlice: destinationSlice, destinationLevel: destinationLevel, destinationOrigin: destinationOrigin, options: options)
	}
	
	@inline(__always)
	func copyFromTexture(sourceTexture: MTLTexture, sourceSlice: Int, sourceLevel: Int, sourceOrigin: MTLOrigin, sourceSize: MTLSize, toMemory destinationMemory: MetalMemory, destinationBytesPerRow: Int, destinationBytesPerImage: Int, options: MTLBlitOption) {
		copyFromTexture(sourceTexture, sourceSlice: sourceSlice, sourceLevel: sourceLevel, sourceOrigin: sourceOrigin, sourceSize: sourceSize, toBuffer: destinationMemory.buffer, destinationOffset: destinationMemory.offset, destinationBytesPerRow: destinationBytesPerRow, destinationBytesPerImage: destinationBytesPerImage, options: options)
	}
}