//
//  ViewController.swift
//  Example-iOS
//
//  Created by Silvan Mosberger on 28/07/16.
//
//

import UIKit
import MetalKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

class DrawingView : MTKView {
	var renderer : Renderer?
	
//	func normalizedPoint(forEvent event: NSEvent) -> float2 {
//		let point = convertPoint(event.locationInWindow, fromView: window?.contentView)
//		return float2(Float(point.x / frame.width), Float(point.y / frame.height)) * 2 - float2(1)
//	}
//	
//	override func mouseDown(theEvent: NSEvent) {
//		renderer?.startLine(atPoint: normalizedPoint(forEvent: theEvent))
//	}
//	
//	override func mouseDragged(theEvent: NSEvent) {
//		renderer?.appendToLastLine(point: normalizedPoint(forEvent: theEvent))
//	}
}
