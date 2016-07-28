//
//  ViewController.swift
//  Example
//
//  Created by Silvan Mosberger on 27/07/16.
//
//

import Cocoa
import MetalKit
import MetalMemory
import Carbon

class ViewController: NSViewController, NSGestureRecognizerDelegate {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let drawingView = view as! DrawingView
		drawingView.renderer = Renderer(view: drawingView)
	}
}

class DrawingView : MTKView {
	var renderer : Renderer!
	
	override var acceptsFirstResponder: Bool { return true }
	
	override func mouseDown(theEvent: NSEvent) {
		let point = convertPoint(theEvent.locationInWindow, fromView: window?.contentView)
		let normalizedPoint = (Float(point.x / frame.width), Float(point.y / frame.height))
		renderer.startLine(atPoint: normalizedPoint)
	}
	
	override func mouseDragged(theEvent: NSEvent) {
		let point = convertPoint(theEvent.locationInWindow, fromView: window?.contentView)
		let normalizedPoint = (Float(point.x / frame.width), Float(point.y / frame.height))
		renderer.appendToLastLine(point: normalizedPoint)
	}
	
	override func keyDown(theEvent: NSEvent) {
		guard theEvent.charactersIgnoringModifiers == "z" && theEvent.modifierFlags.contains(NSEventModifierFlags.CommandKeyMask) && !renderer.lines.isEmpty else { return }
		renderer.lines.removeLast()
	}
}

typealias Point = (x: Float, y: Float)

class Renderer : NSObject, MTKViewDelegate {
	let device : MTLDevice
	
	let library : MTLLibrary
	let queue : MTLCommandQueue
	let pipeline : MTLRenderPipelineState
	
	let points = UniformArray<Point>()
	
	typealias Line = (start: Int, count: Int)
	
	var lines : [Line] = []
	
	init(view: MTKView, device: MTLDevice = MTLCreateSystemDefaultDevice()!) {
		self.device = device
		view.device = device
		points.device = device
		
		let samples = 4
		view.sampleCount = samples
		
		library = device.newDefaultLibrary()!
		queue = device.newCommandQueue()
		
		let pipeDesc = MTLRenderPipelineDescriptor()
		pipeDesc.vertexFunction = library.newFunctionWithName("basicVertex")!
		pipeDesc.fragmentFunction = library.newFunctionWithName("basicFragment")!
		
		pipeDesc.sampleCount = samples
		
		pipeDesc.colorAttachments[0].pixelFormat = view.colorPixelFormat
		
		pipeline = try! device.newRenderPipelineStateWithDescriptor(pipeDesc)
		
		view.clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 1)
		
		super.init()
		
		view.delegate = self
	}
	
	func startLine(atPoint point: Point) {
		points.append(point)
		lines.append((points.count, 0))
	}
	
	func appendToLastLine(point point: Point) {
		guard !lines.isEmpty else { return }
		points.append(point)
		lines[lines.endIndex - 1].count += 1
	}
	
	func mtkView(view: MTKView, drawableSizeWillChange size: CGSize) {
		
	}
	
	func drawInMTKView(view: MTKView) {
		guard let drawable = view.currentDrawable, passDescriptor = view.currentRenderPassDescriptor else {
			print("No drawable or renderPassDescriptor")
			return
		}
		
		let commands = queue.commandBuffer()
		
		let encoder = commands.renderCommandEncoderWithDescriptor(passDescriptor)
		
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