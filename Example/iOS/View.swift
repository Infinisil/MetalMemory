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
		let point = touch.location(in: self)
		return float2(Float(point.x / frame.width), Float(1 - point.y / frame.height)) * 2 - float2(1)
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first , currentTouch == nil else { return }
		currentTouch = touch
		renderer?.startLine(atPoint: touchPoint(forTouch: touch))
	}

	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = currentTouch , touches.contains(touch) else { return }
		renderer?.appendToLastLine(point: touchPoint(forTouch: touch))
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		currentTouch = nil
	}
}
