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

public protocol TextFieldDelegate : UITextFieldDelegate {}

@IBDesignable
open class TextField : UITextField, CAAnimationDelegate {
	/// A Boolean that indicates if the TextField is in an animating state.
	open fileprivate(set) var animating: Bool = false
	
	/**
	This property is the same as clipsToBounds. It crops any of the view's
	contents from bleeding past the view's frame.
	*/
	@IBInspectable open var masksToBounds: Bool {
		get {
			return layer.masksToBounds
		}
		set(value) {
			layer.masksToBounds = value
		}
	}
    
    /// A property that accesses the backing layer's backgroundColor.
	@IBInspectable open override var backgroundColor: UIColor? {
		didSet {
			layer.backgroundColor = backgroundColor?.cgColor
		}
	}
	
	/// A property that accesses the layer.frame.origin.x property.
	@IBInspectable open var x: CGFloat {
		get {
			return layer.frame.origin.x
		}
		set(value) {
			layer.frame.origin.x = value
		}
	}
	
	/// A property that accesses the layer.frame.origin.y property.
	@IBInspectable open var y: CGFloat {
		get {
			return layer.frame.origin.y
		}
		set(value) {
			layer.frame.origin.y = value
		}
	}
	
	/// A property that accesses the layer.frame.size.width property.
	@IBInspectable open var width: CGFloat {
		get {
			return layer.frame.size.width
		}
		set(value) {
			layer.frame.size.width = value
		}
	}
	
	/// A property that accesses the layer.frame.size.height property.
	@IBInspectable open var height: CGFloat {
		get {
			return layer.frame.size.height
		}
		set(value) {
			layer.frame.size.height = value
		}
	}
	
	/// A property that accesses the layer.position property.
	@IBInspectable open var position: CGPoint {
		get {
			return layer.position
		}
		set(value) {
			layer.position = value
		}
	}
	
	/// A property that accesses the layer.zPosition property.
	@IBInspectable open var zPosition: CGFloat {
		get {
			return layer.zPosition
		}
		set(value) {
			layer.zPosition = value
		}
	}
	
	/// Reference to the divider.
	open fileprivate(set) lazy var divider: CAShapeLayer = CAShapeLayer()
	
	/// Divider height.
	@IBInspectable open var dividerHeight: CGFloat = 1
	
	/// Divider active state height.
	@IBInspectable open var dividerActiveHeight: CGFloat = 2
	
	/// Sets the divider.
	@IBInspectable open var dividerColor: UIColor = MaterialColor.darkText.dividers {
		didSet {
			if !isEditing {
				divider.backgroundColor = dividerColor.cgColor
			}
		}
	}
	
	/// Sets the divider.
	@IBInspectable open var dividerActiveColor: UIColor? {
		didSet {
			if let v: UIColor = dividerActiveColor {
				if isEditing {
					divider.backgroundColor = v.cgColor
				}
			}
		}
	}
	
	/// The placeholderLabel font value.
	@IBInspectable open override var font: UIFont? {
		didSet {
			placeholderLabel.font = font
		}
	}
 
	/// TextField's text property observer.
	@IBInspectable open override var text: String? {
		didSet {
			if true == text?.isEmpty && !isFirstResponder {
				placeholderEditingDidEndAnimation()
			}
		}
	}
	
	/// The placeholderLabel text value.
	@IBInspectable open override var placeholder: String? {
		get {
			return placeholderLabel.text
		}
		set(value) {
			placeholderLabel.text = value
			if let v: String = value {
				placeholderLabel.attributedText = NSAttributedString(string: v, attributes: [NSForegroundColorAttributeName: placeholderColor])
			}
		}
	}
	
	/// The placeholder UILabel.
	@IBInspectable open fileprivate(set) lazy var placeholderLabel: UILabel = UILabel(frame: CGRect.zero)
	
	/// Placeholder textColor.
	@IBInspectable open var placeholderColor: UIColor = MaterialColor.darkText.others {
		didSet {
			if !isEditing {
				if let v: String = placeholder {
					placeholderLabel.attributedText = NSAttributedString(string: v, attributes: [NSForegroundColorAttributeName: placeholderColor])
				}
			}
		}
	}
	
	/// Placeholder active textColor.
	@IBInspectable open var placeholderActiveColor: UIColor = MaterialColor.blue.base {
		didSet {
			if isEditing {
				if let v: String = placeholder {
					placeholderLabel.attributedText = NSAttributedString(string: v, attributes: [NSForegroundColorAttributeName: placeholderActiveColor])
				}
			}
			tintColor = placeholderActiveColor
		}
	}
	
	/// This property adds a padding to placeholder y position animation
	open var placeholderVerticalOffset: CGFloat = 0
	
	/// The detailLabel UILabel that is displayed.
	@IBInspectable open fileprivate(set) lazy var detailLabel: UILabel = UILabel(frame: CGRect.zero)
	
	
	/// The detailLabel text value.
	@IBInspectable open var detail: String? {
		get {
			return detailLabel.text
		}
		set(value) {
			detailLabel.text = value
			if let v: String = value {
				detailLabel.attributedText = NSAttributedString(string: v, attributes: [NSForegroundColorAttributeName: detailColor])
			}
			layoutDetailLabel()
		}
	}
	
	/// Detail textColor.
	@IBInspectable open var detailColor: UIColor = MaterialColor.darkText.others {
		didSet {
			if let v: String = detailLabel.text {
				detailLabel.attributedText = NSAttributedString(string: v, attributes: [NSForegroundColorAttributeName: detailColor])
			}
		}
	}
    
	/// Vertical distance for the detailLabel from the divider.
	@IBInspectable open var detailVerticalOffset: CGFloat = 8 {
		didSet {
			layoutDetailLabel()
		}
	}
	
	/// Handles the textAlignment of the placeholderLabel.
	open override var textAlignment: NSTextAlignment {
		get {
			return super.textAlignment
		}
		set(value) {
			super.textAlignment = value
			placeholderLabel.textAlignment = value
			detailLabel.textAlignment = value
		}
	}
	
	/// Enables the clearIconButton.
	@IBInspectable open var enableClearIconButton: Bool {
		get {
			return nil != clearIconButton
		}
		set(value) {
			if value {
				if nil == clearIconButton {
					let image: UIImage? = MaterialIcon.cm.clear
					clearIconButton = IconButton(frame: CGRect.zero)
					clearIconButton!.contentEdgeInsets = UIEdgeInsets.zero
					clearIconButton!.pulseAnimation = .center
					clearIconButton!.tintColor = placeholderColor
					clearIconButton!.setImage(image, for: UIControlState())
					clearIconButton!.setImage(image, for: .highlighted)
					clearButtonMode = .never
					rightViewMode = .whileEditing
					rightView = clearIconButton
					clearIconButtonAutoHandle = clearIconButtonAutoHandle ? true : false
				}
			} else {
				clearIconButton?.removeTarget(self, action: #selector(handleClearIconButton), for: .touchUpInside)
				clearIconButton = nil
			}
		}
	}
	
	/// Enables the automatic handling of the clearIconButton.
	@IBInspectable open var clearIconButtonAutoHandle: Bool = true {
		didSet {
			clearIconButton?.removeTarget(self, action: #selector(handleClearIconButton), for: .touchUpInside)
			if clearIconButtonAutoHandle {
				clearIconButton?.addTarget(self, action: #selector(handleClearIconButton), for: .touchUpInside)
			}
		}
	}
	
	/// Enables the visibilityIconButton.
	@IBInspectable open var enableVisibilityIconButton: Bool {
		get {
			return nil != visibilityIconButton
		}
		set(value) {
			if value {
				if nil == visibilityIconButton {
					let image: UIImage? = MaterialIcon.visibility
					visibilityIconButton = IconButton(frame: CGRect.zero)
					visibilityIconButton!.contentEdgeInsets = UIEdgeInsets.zero
					visibilityIconButton!.pulseAnimation = .center
					visibilityIconButton!.tintColor = placeholderColor
					visibilityIconButton!.setImage(image, for: UIControlState())
					visibilityIconButton!.setImage(image, for: .highlighted)
					visibilityIconButton!.tintColor = placeholderColor.withAlphaComponent(isSecureTextEntry ? 0.38 : 0.54)
					isSecureTextEntry = true
					clearButtonMode = .never
					rightViewMode = .whileEditing
					rightView = visibilityIconButton
					visibilityIconButtonAutoHandle = visibilityIconButtonAutoHandle ? true : false
				}
			} else {
				visibilityIconButton?.removeTarget(self, action: #selector(handleVisibilityIconButton), for: .touchUpInside)
				visibilityIconButton = nil
			}
		}
	}
	
	/// Enables the automatic handling of the visibilityIconButton.
	@IBInspectable open var visibilityIconButtonAutoHandle: Bool = true {
		didSet {
			visibilityIconButton?.removeTarget(self, action: #selector(handleVisibilityIconButton), for: .touchUpInside)
			if visibilityIconButtonAutoHandle {
				visibilityIconButton?.addTarget(self, action: #selector(handleVisibilityIconButton), for: .touchUpInside)
			}
		}
	}
	
	/// A reference to the clearIconButton.
	open fileprivate(set) var clearIconButton: IconButton?
	
	/// A reference to the visibilityIconButton.
	open fileprivate(set) var visibilityIconButton: IconButton?
	
	/**
	An initializer that initializes the object with a NSCoder object.
	- Parameter aDecoder: A NSCoder instance.
	*/
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		prepareView()
	}
	
	/**
	An initializer that initializes the object with a CGRect object.
	If AutoLayout is used, it is better to initilize the instance
	using the init() initializer.
	- Parameter frame: A CGRect instance.
	*/
	public override init(frame: CGRect) {
		super.init(frame: frame)
		prepareView()
	}
	
	/// A convenience initializer.
	public convenience init() {
		self.init(frame: CGRect.zero)
	}
	
	open override func layoutSubviews() {
		super.layoutSubviews()
		layoutToSize()
	}
	
    open override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        if self.layer == layer {
            layoutDivider()
        }
    }
	
	/// Default size when using AutoLayout.
	open override var intrinsicContentSize : CGSize {
		return CGSize(width: width, height: 32)
	}
	
	/**
	A method that accepts CAAnimation objects and executes them on the
	view's backing layer.
	- Parameter animation: A CAAnimation instance.
	*/
	open func animate(_ animation: CAAnimation) {
		animation.delegate = self
		if let a: CABasicAnimation = animation as? CABasicAnimation {
			a.fromValue = (nil == layer.presentation() ? layer : layer.presentation()!).value(forKeyPath: a.keyPath!)
		}
		if let a: CAPropertyAnimation = animation as? CAPropertyAnimation {
			layer.add(a, forKey: a.keyPath!)
		} else if let a: CAAnimationGroup = animation as? CAAnimationGroup {
			layer.add(a, forKey: nil)
		} else if let a: CATransition = animation as? CATransition {
			layer.add(a, forKey: kCATransition)
		}
	}
	
	/**
	A delegation method that is executed when the backing layer starts
	running an animation.
	- Parameter anim: The currently running CAAnimation instance.
	*/
	open func animationDidStart(_ anim: CAAnimation) {
		(delegate as? MaterialAnimationDelegate)?.materialAnimationDidStart?(anim)
	}
	
	/**
	A delegation method that is executed when the backing layer stops
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
						layer.setValue(v, forKeyPath: k)
						layer.removeAnimation(forKey: k)
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
	
	/// Handles the text editing did begin state.
	open func handleEditingDidBegin() {
		dividerEditingDidBeginAnimation()
		placeholderEditingDidBeginAnimation()
	}
	
	/// Handles the text editing did end state.
	open func handleEditingDidEnd() {
		dividerEditingDidEndAnimation()
		placeholderEditingDidEndAnimation()
	}
	
	/// Handles the clearIconButton TouchUpInside event.
	open func handleClearIconButton() {
		if false == delegate?.textFieldShouldClear?(self) {
			return
		}
		text = nil
	}
	
	/// Handles the visibilityIconButton TouchUpInside event.
	open func handleVisibilityIconButton() {
		isSecureTextEntry = !isSecureTextEntry
		if !isSecureTextEntry {
			super.font = nil
			font = placeholderLabel.font
		}
		visibilityIconButton?.tintColor = visibilityIconButton?.tintColor.withAlphaComponent(isSecureTextEntry ? 0.38 : 0.54)
	}
	
	/**
	Prepares the view instance when intialized. When subclassing,
	it is recommended to override the prepareView method
	to initialize property values and other setup operations.
	The super.prepareView method should always be called immediately
	when subclassing.
	*/
	open func prepareView() {
		super.placeholder = nil
		masksToBounds = false
		borderStyle = .none
		backgroundColor = nil
		font = RobotoFont.regularWithSize(16)
		contentScaleFactor = MaterialDevice.scale
		prepareDivider()
		preparePlaceholderLabel()
		prepareDetailLabel()
		prepareTargetHandlers()
        prepareTextAlignment()
	}
	
	/// Ensures that the components are sized correctly.
	open func layoutToSize() {
		if !animating {
			layoutPlaceholderLabel()
			layoutDetailLabel()
			layoutClearIconButton()
			layoutVisibilityIconButton()
		}
	}
	
	/// Layout the divider.
	open func layoutDivider() {
		divider.frame = CGRect(x: 0, y: height, width: width, height: isEditing ? dividerActiveHeight : dividerHeight)
	}
	
	/// Layout the placeholderLabel.
	open func layoutPlaceholderLabel() {
		if !isEditing && true == text?.isEmpty {
			placeholderLabel.frame = bounds
		} else if placeholderLabel.transform.isIdentity {
			placeholderLabel.frame = bounds
			placeholderLabel.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
			switch textAlignment {
			case .left, .natural:
				placeholderLabel.frame.origin.x = 0
			case .right:
				placeholderLabel.frame.origin.x = width - placeholderLabel.frame.width
			default:break
			}
			placeholderLabel.frame.origin.y = -placeholderLabel.frame.size.height + placeholderVerticalOffset
			placeholderLabel.textColor = placeholderColor
		} else {
			switch textAlignment {
			case .left, .natural:
				placeholderLabel.frame.origin.x = 0
			case .right:
				placeholderLabel.frame.origin.x = width - placeholderLabel.frame.width
			case .center:
				placeholderLabel.center.x = width / 2
			default:break
			}
			placeholderLabel.frame.size.width = width * 0.75
		}
	}
	
	/// Layout the detailLabel.
	open func layoutDetailLabel() {
		let h: CGFloat = nil == detail ? 12 : detailLabel.font.stringSize(detail!, constrainedToWidth: Double(width)).height
		detailLabel.frame = CGRect(x: 0, y: divider.frame.origin.y + detailVerticalOffset, width: width, height: h)
	}
	
	/// Layout the clearIconButton.
	open func layoutClearIconButton() {
		if let v: IconButton = clearIconButton {
			if 0 < width && 0 < height {
				v.frame = CGRect(x: width - height, y: 0, width: height, height: height)
			}
		}
	}
	
	/// Layout the visibilityIconButton.
	open func layoutVisibilityIconButton() {
		if let v: IconButton = visibilityIconButton {
			if 0 < width && 0 < height {
				v.frame = CGRect(x: width - height, y: 0, width: height, height: height)
			}
		}
	}
	
	/// The animation for the divider when editing begins.
	open func dividerEditingDidBeginAnimation() {
		divider.frame.size.height = dividerActiveHeight
		divider.backgroundColor = nil == dividerActiveColor ? placeholderActiveColor.cgColor : dividerActiveColor!.cgColor
	}
	
	/// The animation for the divider when editing ends.
	open func dividerEditingDidEndAnimation() {
		divider.frame.size.height = dividerHeight
		divider.backgroundColor = dividerColor.cgColor
	}
	
	/// The animation for the placeholder when editing begins.
	open func placeholderEditingDidBeginAnimation() {
		if placeholderLabel.transform.isIdentity {
			animating = true
			UIView.animate(withDuration: 0.15, animations: { [weak self] in
				if let v: TextField = self {
					v.placeholderLabel.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
					switch v.textAlignment {
					case .left, .natural:
						v.placeholderLabel.frame.origin.x = 0
					case .right:
						v.placeholderLabel.frame.origin.x = v.width - v.placeholderLabel.frame.width
					default:break
					}
					v.placeholderLabel.frame.origin.y = -v.placeholderLabel.frame.size.height + v.placeholderVerticalOffset
					v.placeholderLabel.textColor = v.placeholderActiveColor
				}
			}, completion: { [weak self] _ in
				self?.animating = false
			}) 
		} else if isEditing {
			placeholderLabel.textColor = placeholderActiveColor
		}
	}
	
	/// The animation for the placeholder when editing ends.
	open func placeholderEditingDidEndAnimation() {
		if !placeholderLabel.transform.isIdentity && true == text?.isEmpty {
			animating = true
			UIView.animate(withDuration: 0.15, animations: { [weak self] in
				if let v: TextField = self {
					v.placeholderLabel.transform = CGAffineTransform.identity
					v.placeholderLabel.frame.origin.x = 0
					v.placeholderLabel.frame.origin.y = 0
					v.placeholderLabel.textColor = v.placeholderColor
				}
			}, completion: { [weak self] _ in
				self?.animating = false
			}) 
		} else if !isEditing {
			placeholderLabel.textColor = placeholderColor
		}
	}
	
	/// Prepares the divider.
	fileprivate func prepareDivider() {
		dividerColor = MaterialColor.darkText.dividers
		layer.addSublayer(divider)
	}
	
	/// Prepares the placeholderLabel.
	fileprivate func preparePlaceholderLabel() {
		placeholderColor = MaterialColor.darkText.others
		addSubview(placeholderLabel)
	}
	
	/// Prepares the detailLabel.
	fileprivate func prepareDetailLabel() {
		detailLabel.font = RobotoFont.regularWithSize(12)
		detailColor = MaterialColor.darkText.others
		addSubview(detailLabel)
	}
	
	/// Prepares the target handlers.
	fileprivate func prepareTargetHandlers() {
		addTarget(self, action: #selector(handleEditingDidBegin), for: .editingDidBegin)
		addTarget(self, action: #selector(handleEditingDidEnd), for: .editingDidEnd)
	}
    
    /// Prepares the textAlignment.
    fileprivate func prepareTextAlignment() {
        textAlignment = .rightToLeft == UIApplication.shared.userInterfaceLayoutDirection ? .right : .left
    }
}
