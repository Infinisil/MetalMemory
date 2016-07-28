//
//  ViewController.swift
//  Example
//
//  Created by Silvan Mosberger on 27/07/16.
//
//

import Cocoa
import MetalKit

class ViewController: NSViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let drawingView = view as! DrawingView
		drawingView.renderer = Renderer(view: drawingView)
	}
}

class DrawingView : MTKView {
	var renderer : Renderer?
	
	func normalizedPoint(forEvent event: NSEvent) -> float2 {
		let point = convertPoint(event.locationInWindow, fromView: window?.contentView)
		return float2(Float(point.x / frame.width), Float(point.y / frame.height)) * 2 - float2(1)
	}
	
	override func mouseDown(theEvent: NSEvent) {
		renderer?.startLine(atPoint: normalizedPoint(forEvent: theEvent))
	}
	
	override func mouseDragged(theEvent: NSEvent) {
		renderer?.appendToLastLine(point: normalizedPoint(forEvent: theEvent))
	}
}
