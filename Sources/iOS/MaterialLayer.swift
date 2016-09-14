/*
* Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>.
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*
*	*	Redistributions of source code must retain the above copyright notice, this
*		list of conditions and the following disclaimer.
*
*	*	Redistributions in binary form must reproduce the above copyright notice,
*		this list of conditions and the following disclaimer in the documentation
*		and/or other materials provided with the distribution.
*
*	*	Neither the name of Material nor the names of its
*		contributors may be used to endorse or promote products derived from
*		this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
* FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
* DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
* CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
* OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
* OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import UIKit

@objc(MaterialDelegate)
public protocol MaterialDelegate {}

@objc(MaterialLayer)
open class MaterialLayer : CAShapeLayer, CAAnimationDelegate {
	/**
	A CAShapeLayer used to manage elements that would be affected by
	the clipToBounds property of the backing layer. For example, this
	allows the dropshadow effect on the backing layer, while clipping
	the image to a desired shape within the visualLayer.
	*/
	open fileprivate(set) lazy var visualLayer: CAShapeLayer = CAShapeLayer()

	/// A property that accesses the layer.frame.origin.x property.
	@IBInspectable open var x: CGFloat {
		get {
			return frame.origin.x
		}
		set(value) {
			frame.origin.x = value
		}
	}
	
	/// A property that accesses the layer.frame.origin.y property.
	@IBInspectable open var y: CGFloat {
		get {
			return frame.origin.y
		}
		set(value) {
			frame.origin.y = value
		}
	}
	
	/**
	A property that accesses the layer.frame.size.width property.
	When setting this property in conjunction with the shape property having a
	value that is not .None, the height will be adjusted to maintain the correct
	shape.
	*/
	@IBInspectable open var width: CGFloat {
		get {
			return frame.size.width
		}
		set(value) {
			frame.size.width = value
			if .none != shape {
				frame.size.height = value
			}
		}
	}
	
	/**
	A property that accesses the layer.frame.size.height property.
	When setting this property in conjunction with the shape property having a
	value that is not .None, the width will be adjusted to maintain the correct
	shape.
	*/
	@IBInspectable open var height: CGFloat {
		get {
			return frame.size.height
		}
		set(value) {
			frame.size.height = value
			if .none != shape {
				frame.size.width = value
			}
		}
	}
	
	/**
	A property that manages an image for the visualLayer's contents
	property. Images should not be set to the backing layer's contents
	property to avoid conflicts when using clipsToBounds.
	*/
	@IBInspectable open var image: UIImage? {
		didSet {
			visualLayer.contents = image?.cgImage
		}
	}
	
	/**
	Allows a relative subrectangle within the range of 0 to 1 to be
	specified for the visualLayer's contents property. This allows
	much greater flexibility than the contentsGravity property in
	terms of how the image is cropped and stretched.
	*/
	open override var contentsRect: CGRect {
		didSet {
			visualLayer.contentsRect = contentsRect
		}
	}
	
	/**
	A CGRect that defines a stretchable region inside the visualLayer
	with a fixed border around the edge.
	*/
	open override var contentsCenter: CGRect {
		didSet {
			visualLayer.contentsCenter = contentsCenter
		}
	}
	
	/**
	A floating point value that defines a ratio between the pixel
	dimensions of the visualLayer's contents property and the size
	of the layer. By default, this value is set to the MaterialDevice.scale.
	*/
	@IBInspectable open override var contentsScale: CGFloat {
		didSet {
			visualLayer.contentsScale = contentsScale
		}
	}
	
	/// A Preset for the contentsGravity property.
	open var contentsGravityPreset: MaterialGravity {
		didSet {
			contentsGravity = MaterialGravityToValue(contentsGravityPreset)
		}
	}
	
	/// Determines how content should be aligned within the visualLayer's bounds.
	@IBInspectable open override var contentsGravity: String {
		get {
			return visualLayer.contentsGravity
		}
		set(value) {
			visualLayer.contentsGravity = value
		}
	}
	
	/// Enables automatic shadowPath sizing.
	@IBInspectable open var shadowPathAutoSizeEnabled: Bool = true {
		didSet {
			if shadowPathAutoSizeEnabled {
				layoutShadowPath()
			}
		}
	}
	
	/**
	A property that sets the shadowOffset, shadowOpacity, and shadowRadius
	for the backing layer. This is the preferred method of setting depth
	in order to maintain consitency across UI objects.
	*/
	open var depth: MaterialDepth = .none {
		didSet {
			let value: MaterialDepthType = MaterialDepthToValue(depth)
			shadowOffset = value.offset
			shadowOpacity = value.opacity
			shadowRadius = value.radius
			layoutShadowPath()
		}
	}
	
	/**
	A property that sets the cornerRadius of the backing layer. If the shape
	property has a value of .Circle when the cornerRadius is set, it will
	become .None, as it no longer maintains its circle shape.
	*/
	open var cornerRadiusPreset: MaterialRadius = .none {
		didSet {
			if let v: MaterialRadius = cornerRadiusPreset {
				cornerRadius = MaterialRadiusToValue(v)
			}
		}
	}
	
	/**
	A property that sets the cornerRadius of the backing layer. If the shape
	property has a value of .Circle when the cornerRadius is set, it will
	become .None, as it no longer maintains its circle shape.
	*/
	@IBInspectable open override var cornerRadius: CGFloat {
		didSet {
			layoutShadowPath()
			if .circle == shape {
				shape = .none
			}
		}
	}
	
	/**
	A property that manages the overall shape for the object. If either the
	width or height property is set, the other will be automatically adjusted
	to maintain the shape of the object.
	*/
	open var shape: MaterialShape = .none {
		didSet {
			if .none != shape {
				if width < height {
					frame.size.width = height
				} else {
					frame.size.height = width
				}
				layoutShadowPath()
			}
		}
	}
	
	/// A preset property to set the borderWidth.
	open var borderWidthPreset: MaterialBorder = .none {
		didSet {
			borderWidth = MaterialBorderToValue(borderWidthPreset)
		}
	}
	
	/**
	An initializer that initializes the object with a NSCoder object.
	- Parameter aDecoder: A NSCoder instance.
	*/
	public required init?(coder aDecoder: NSCoder) {
		contentsGravityPreset = .resizeAspectFill
		super.init(coder: aDecoder)
		prepareVisualLayer()
	}
	
	/**
	An initializer the same as init(). The layer parameter is ignored
	to avoid crashes on certain architectures.
	- Parameter layer: AnyObject.
	*/
	public override init(layer: Any) {
		contentsGravityPreset = .resizeAspectFill
		super.init()
		prepareVisualLayer()
	}
	
	/// A convenience initializer.
	public override init() {
		contentsGravityPreset = .resizeAspectFill
		super.init()
		prepareVisualLayer()
	}
	
	/**
	An initializer that initializes the object with a CGRect object.
	- Parameter frame: A CGRect instance.
	*/
	public convenience init(frame: CGRect) {
		self.init()
		self.frame = frame
	}
	
	open override func layoutSublayers() {
		super.layoutSublayers()
		layoutShape()
		layoutVisualLayer()
		layoutShadowPath()
	}
	
	/**
	A method that accepts CAAnimation objects and executes.
	- Parameter animation: A CAAnimation instance.
	*/
	open func animate(_ animation: CAAnimation) {
		animation.delegate = self
		if let a: CABasicAnimation = animation as? CABasicAnimation {
			a.fromValue = (nil == presentation() ? self : presentation()!).value(forKeyPath: a.keyPath!)
		}
		if let a: CAPropertyAnimation = animation as? CAPropertyAnimation {
			add(a, forKey: a.keyPath!)
		} else if let a: CAAnimationGroup = animation as? CAAnimationGroup {
			add(a, forKey: nil)
		} else if let a: CATransition = animation as? CATransition {
			add(a, forKey: kCATransition)
		}
	}
	
	/**
	A delegation method that is executed when the layer starts
	running an animation.
	- Parameter anim: The currently running CAAnimation instance.
	*/
	open func animationDidStart(_ anim: CAAnimation) {
		(delegate as? MaterialAnimationDelegate)?.materialAnimationDidStart?(anim)
	}
	
	/**
	A delegation method that is executed when the layer stops
	running an animation.
	- Parameter anim: The CAAnimation instance that stopped running.
	- Parameter flag: A boolean that indicates if the animation stopped
	because it was completed or interrupted. True if completed, false
	if interrupted.
	*/
	open func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
		if let a: CAPropertyAnimation = anim as? CAPropertyAnimation {
			if let b: CABasicAnimation = a as? CABasicAnimation {
				if let v: AnyObject = b.toValue as AnyObject? {
					if let k: String = b.keyPath {
						setValue(v, forKeyPath: k)
						removeAnimation(forKey: k)
					}
				}
			}
			(delegate as? MaterialAnimationDelegate)?.materialAnimationDidStop?(anim, finished: flag)
		} else if let a: CAAnimationGroup = anim as? CAAnimationGroup {
			for x in a.animations! {
				animationDidStop(x, finished: true)
			}
		}
	}
	
	/// Prepares the visualLayer property.
	open func prepareVisualLayer() {
		// visualLayer
		visualLayer.zPosition = 0
		visualLayer.masksToBounds = true
		addSublayer(visualLayer)
	}
	
	/// Manages the layout for the visualLayer property.
	internal func layoutVisualLayer() {
		visualLayer.frame = bounds
		visualLayer.cornerRadius = cornerRadius
	}
	
	/// Manages the layout for the shape of the layer instance.
	internal func layoutShape() {
		if .circle == shape {
			let w: CGFloat = (width / 2)
			if w != cornerRadius {
				cornerRadius = w
			}
		}
	}
	
	/// Sets the shadow path.
	internal func layoutShadowPath() {
		if shadowPathAutoSizeEnabled {
			if .none == depth {
				shadowPath = nil
			} else if nil == shadowPath {
				shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
			} else {
				animate(MaterialAnimation.shadowPath(UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath, duration: 0))
			}
		}
	}
}
