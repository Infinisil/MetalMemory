//
//  Renderer.swift
//  MetalMemory
//
//  Created by Silvan Mosberger on 28/07/16.
//  
//

import MetalKit
import MetalMemory

class Renderer : NSObject, MTKViewDelegate {
	typealias Line = (start: Int, count: Int)
	
	let device : MTLDevice
	
	let library : MTLLibrary
	let queue : MTLCommandQueue
	let pipeline : MTLRenderPipelineState
	
	let points = UniformArray<float2>()
	var lines : [Line] = []
	
	init(view: MTKView, device: MTLDevice = MTLCreateSystemDefaultDevice()!) {
		self.device = device
		points.device = device
		view.device = device
		
		library = device.newDefaultLibrary()!
		queue = device.newCommandQueue()
		
		let pipeDesc = MTLRenderPipelineDescriptor()
		pipeDesc.vertexFunction = library.newFunctionWithName("basicVertex")!
		pipeDesc.fragmentFunction = library.newFunctionWithName("basicFragment")!
		pipeDesc.colorAttachments[0].pixelFormat = view.colorPixelFormat
		
		pipeline = try! device.newRenderPipelineStateWithDescriptor(pipeDesc)
		
		super.init()
		
		view.delegate = self
	}
	
	func startLine(atPoint point: float2) {
		points.append(point)
		lines.append((points.count, 0))
	}
	
	func appendToLastLine(point point: float2) {
		guard !lines.isEmpty else { return }
		points.append(point)
		lines[lines.endIndex - 1].count += 1
	}
	
	func mtkView(view: MTKView, drawableSizeWillChange size: CGSize) {}
	
	func drawInMTKView(view: MTKView) {
		guard let drawable = view.currentDrawable else {
			print("No drawable")
			return
		}
		
		let commands = queue.commandBuffer()
		let encoder = commands.renderCommandEncoderWithDescriptor(view.currentRenderPassDescriptor!)
		encoder.setRenderPipelineState(pipeline)
		
		encoder.setVertexMemory(points, atIndex: 0)
		for line in lines {
			encoder.drawPrimitives(.LineStrip, vertexStart: line.start, vertexCount: line.count)
		}
		
		encoder.endEncoding()
		
		commands.presentDrawable(drawable)
		commands.commit()
	}
}