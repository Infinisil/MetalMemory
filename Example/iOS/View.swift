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
		
		let drawingView = view as! DrawingView
		drawingView.renderer = Renderer(view: drawingView)
	}
}

class DrawingView : MTKView {
	var renderer : Renderer?
	
	var currentTouch : UITouch?

	func touchPoint(forTouch touch: UITouch) -> float2 {
		let point = touch.locationInView(self)
		return float2(Float(point.x / frame.width), Float(1 - point.y / frame.height)) * 2 - float2(1)
	}
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		guard let touch = touches.first where currentTouch == nil else { return }
		currentTouch = touch
		renderer?.startLine(atPoint: touchPoint(forTouch: touch))
	}

	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		guard let touch = currentTouch where touches.contains(touch) else { return }
		renderer?.appendToLastLine(point: touchPoint(forTouch: touch))
	}
	
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		currentTouch = nil
	}
}
