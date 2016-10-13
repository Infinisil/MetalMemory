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
	
	let points = UniformArray<float2>(policy: Policy(rounding: .powerOfTwo, decrease: true))
	var lines : [Line] = []
	
	init(view: MTKView, device: MTLDevice = MTLCreateSystemDefaultDevice()!) {
		self.device = device
		points.device = device
		view.device = device
		
		library = device.newDefaultLibrary()!
		queue = device.makeCommandQueue()
		
		let pipeDesc = MTLRenderPipelineDescriptor()
		pipeDesc.vertexFunction = library.makeFunction(name: "basicVertex")!
		pipeDesc.fragmentFunction = library.makeFunction(name: "basicFragment")!
		pipeDesc.colorAttachments[0].pixelFormat = view.colorPixelFormat
		
		pipeline = try! device.makeRenderPipelineState(descriptor: pipeDesc)
		
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
	
	func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
	
	func draw(in view: MTKView) {
		guard let drawable = view.currentDrawable else {
			print("No drawable")
			return
		}
		
		let commands = queue.makeCommandBuffer()
		let encoder = commands.makeRenderCommandEncoder(descriptor: view.currentRenderPassDescriptor!)
		encoder.setRenderPipelineState(pipeline)
		
		encoder.setVertexMemory(points, atIndex: 0)
		for line in lines {
			encoder.drawPrimitives(type: .lineStrip, vertexStart: line.start, vertexCount: line.count)
		}
		
		encoder.endEncoding()
		
		commands.present(drawable)
		commands.commit()
	}
}
