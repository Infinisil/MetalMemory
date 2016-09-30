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
	func setVertexMemory(_ memory: MetalMemory, atIndex index: Int) {
		setVertexBuffer(memory.buffer, offset: memory.offset, at: index)
	}
	
	@inline(__always)
	func setFragmentMemory(_ memory: MetalMemory, atIndex index: Int) {
		setFragmentBuffer(memory.buffer, offset: memory.offset, at: index)
	}
	
	@inline(__always)
	func drawPrimitives(_ primitiveType: MTLPrimitiveType, indirectMemory: MetalMemory) {
		drawPrimitives(type: primitiveType, indirectBuffer: indirectMemory.buffer, indirectBufferOffset: indirectMemory.offset)
	}
	
	@inline(__always)
	func drawIndexedPrimitives(_ primitiveType: MTLPrimitiveType, indexCount: Int, indexType: MTLIndexType, indexMemory: MetalMemory, instanceCount: Int, baseVertex: Int, baseInstance: Int) {
		drawIndexedPrimitives(type: primitiveType, indexCount: indexCount, indexType: indexType, indexBuffer: indexMemory.buffer, indexBufferOffset: indexMemory.offset, instanceCount: instanceCount, baseVertex: baseVertex, baseInstance: baseInstance)
	}
	
	@inline(__always)
	func drawIndexedPrimitives(_ primitiveType: MTLPrimitiveType, indexType: MTLIndexType, indexMemory: MetalMemory, indirectMemory: MetalMemory) {
		drawIndexedPrimitives(type: primitiveType, indexType: indexType, indexBuffer: indexMemory.buffer, indexBufferOffset: indexMemory.offset, indirectBuffer: indirectMemory.buffer, indirectBufferOffset: indirectMemory.offset)
	}
	
	@inline(__always)
	func drawIndexedPrimitives(_ primitiveType: MTLPrimitiveType, indexCount: Int, indexType: MTLIndexType, indexMemory: MetalMemory) {
		drawIndexedPrimitives(type: primitiveType, indexCount: indexCount, indexType: indexType, indexBuffer: indexMemory.buffer, indexBufferOffset: indexMemory.offset)
	}

	@inline(__always)
	func drawIndexedPrimitives(_ primitiveType: MTLPrimitiveType, indexCount: Int, indexType: MTLIndexType, indexMemory: MetalMemory, instanceCount: Int) {
		drawIndexedPrimitives(type: primitiveType, indexCount: indexCount, indexType: indexType, indexBuffer: indexMemory.buffer, indexBufferOffset: indexMemory.offset, instanceCount: instanceCount)
	}
}

public extension MTLComputeCommandEncoder {
	@inline(__always)
	func setMemory(_ memory: MetalMemory, atIndex index: Int) {
		setBuffer(memory.buffer, offset: memory.offset, at: index)
	}
	
	@inline(__always)
	func dispatchThreadgroupsWithIndirectMemory(_ memory: MetalMemory, threadsPerThreadgroup: MTLSize) {
		dispatchThreadgroups(indirectBuffer: memory.buffer, indirectBufferOffset: memory.offset, threadsPerThreadgroup: threadsPerThreadgroup)
	}
}

public extension MTLBlitCommandEncoder {
	@inline(__always)
	func fillMemory(_ memory : MetalMemory, range: NSRange, value: UInt8) {
		fill(buffer: memory.buffer, range: NSRange(location: range.location + memory.offset, length: range.length), value: value)
	}
	
	@inline(__always)
	func copyFromMemory(_ sourceMemory: MetalMemory, toMemory: MetalMemory, size: Int) {
		copy(from: sourceMemory.buffer, sourceOffset: sourceMemory.offset, to: toMemory.buffer, destinationOffset: toMemory.offset, size: size)
	}
	
	@inline(__always)
	func copyFromMemory(_ sourceMemory: MetalMemory, sourceBytesPerRow: Int, sourceBytesPerImage: Int, sourceSize: MTLSize, toTexture: MTLTexture, destinationSlice: Int, destinationLevel: Int, destinationOrigin: MTLOrigin) {
		copy(from: sourceMemory.buffer, sourceOffset: sourceMemory.offset, sourceBytesPerRow: sourceBytesPerRow, sourceBytesPerImage: sourceBytesPerImage, sourceSize: sourceSize, to: toTexture, destinationSlice: destinationSlice, destinationLevel: destinationLevel, destinationOrigin: destinationOrigin)
	}
	
	@inline(__always)
	func copyFromTexture(_ sourceTexture: MTLTexture, sourceSlice: Int, sourceLevel: Int, sourceOrigin: MTLOrigin, sourceSize: MTLSize, toMemory destinationMemory: MetalMemory, destinationBytesPerRow: Int, destinationBytesPerImage: Int) {
		copy(from: sourceTexture, sourceSlice: sourceSlice, sourceLevel: sourceLevel, sourceOrigin: sourceOrigin, sourceSize: sourceSize, to: destinationMemory.buffer, destinationOffset: destinationMemory.offset, destinationBytesPerRow: destinationBytesPerRow, destinationBytesPerImage: destinationBytesPerImage)
	}
	
	@inline(__always)
	func copyFromMemory(_ sourceMemory: MetalMemory, sourceBytesPerRow: Int, sourceBytesPerImage: Int, sourceSize: MTLSize, toTexture destinationTexture: MTLTexture, destinationSlice: Int, destinationLevel: Int, destinationOrigin: MTLOrigin, options: MTLBlitOption) {
		copy(from: sourceMemory.buffer, sourceOffset: sourceMemory.offset, sourceBytesPerRow: sourceBytesPerRow, sourceBytesPerImage: sourceBytesPerImage, sourceSize: sourceSize, to: destinationTexture, destinationSlice: destinationSlice, destinationLevel: destinationLevel, destinationOrigin: destinationOrigin, options: options)
	}
	
	@inline(__always)
	func copyFromTexture(_ sourceTexture: MTLTexture, sourceSlice: Int, sourceLevel: Int, sourceOrigin: MTLOrigin, sourceSize: MTLSize, toMemory destinationMemory: MetalMemory, destinationBytesPerRow: Int, destinationBytesPerImage: Int, options: MTLBlitOption) {
		copy(from: sourceTexture, sourceSlice: sourceSlice, sourceLevel: sourceLevel, sourceOrigin: sourceOrigin, sourceSize: sourceSize, to: destinationMemory.buffer, destinationOffset: destinationMemory.offset, destinationBytesPerRow: destinationBytesPerRow, destinationBytesPerImage: destinationBytesPerImage, options: options)
	}
}
