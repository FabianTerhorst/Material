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

public enum MaterialSwitchStyle {
	case lightContent
	case `default`
}

public enum MaterialSwitchState {
	case on
	case off
}

public enum MaterialSwitchSize {
	case small
	case `default`
	case large
}

@objc(MaterialSwitchDelegate)
public protocol MaterialSwitchDelegate {
	/**
	A MaterialSwitch delegate method for state changes.
	- Parameter control: MaterialSwitch control.
	*/
	func materialSwitchStateChanged(_ control: MaterialSwitch)
}

@objc(MaterialSwitch)
@IBDesignable
open class MaterialSwitch : UIControl {
	/// An internal reference to the switchState public property.
	fileprivate var internalSwitchState: MaterialSwitchState = .off
	
	/// Track thickness.
	fileprivate var trackThickness: CGFloat = 0
	
	/// Button diameter.
	fileprivate var buttonDiameter: CGFloat = 0
	
	/// Position when in the .On state.
	fileprivate var onPosition: CGFloat = 0
	
	/// Position when in the .Off state.
	fileprivate var offPosition: CGFloat = 0
	
	/// The bounce offset when animating.
	fileprivate var bounceOffset: CGFloat = 3
	
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
	
	/// An Optional delegation method.
	open weak var delegate: MaterialSwitchDelegate?
	
	/// Indicates if the animation should bounce.
	@IBInspectable open var bounceable: Bool = true {
		didSet {
			bounceOffset = bounceable ? 3 : 0
		}
	}
	
	/// Button on color.
	@IBInspectable open var buttonOnColor: UIColor = MaterialColor.clear {
		didSet {
			styleForState(switchState)
		}
	}
	
	/// Button off color.
	@IBInspectable open var buttonOffColor: UIColor = MaterialColor.clear {
		didSet {
			styleForState(switchState)
		}
	}
	
	/// Track on color.
	@IBInspectable open var trackOnColor: UIColor = MaterialColor.clear {
		didSet {
			styleForState(switchState)
		}
	}
	
	/// Track off color.
	@IBInspectable open var trackOffColor: UIColor = MaterialColor.clear {
		didSet {
			styleForState(switchState)
		}
	}
	
	/// Button on disabled color.
	@IBInspectable open var buttonOnDisabledColor: UIColor = MaterialColor.clear {
		didSet {
			styleForState(switchState)
		}
	}
	
	/// Track on disabled color.
	@IBInspectable open var trackOnDisabledColor: UIColor = MaterialColor.clear {
		didSet {
			styleForState(switchState)
		}
	}
	
	/// Button off disabled color.
	@IBInspectable open var buttonOffDisabledColor: UIColor = MaterialColor.clear {
		didSet {
			styleForState(switchState)
		}
	}
	
	/// Track off disabled color.
	@IBInspectable open var trackOffDisabledColor: UIColor = MaterialColor.clear {
		didSet {
			styleForState(switchState)
		}
	}
	
	/// Track view reference.
	open fileprivate(set) var trackLayer: CAShapeLayer {
		didSet {
			prepareTrack()
		}
	}
	
	/// Button view reference.
	open fileprivate(set) var button: FabButton {
		didSet {
			prepareButton()
		}
	}
	
	@IBInspectable open override var isEnabled: Bool {
		didSet {
			styleForState(internalSwitchState)
		}
	}
	
	/// A boolean indicating if the switch is on or not.
	@IBInspectable open var on: Bool {
		get {
			return .on == internalSwitchState
		}
		set(value) {
			setOn(value, animated: true)
		}
	}

	/// MaterialSwitch state.
	open var switchState: MaterialSwitchState {
		get {
			return internalSwitchState
		}
		set(value) {
			if value != internalSwitchState {
				internalSwitchState = value
			}
		}
	}
	
	/// MaterialSwitch style.
	open var switchStyle: MaterialSwitchStyle = .default {
		didSet {
			switch switchStyle {
			case .lightContent:
				buttonOnColor = MaterialColor.blue.darken2
				trackOnColor = MaterialColor.blue.lighten3
				buttonOffColor = MaterialColor.blueGrey.lighten4
				trackOffColor = MaterialColor.blueGrey.lighten3
				buttonOnDisabledColor = MaterialColor.grey.lighten2
				trackOnDisabledColor = MaterialColor.grey.lighten3
				buttonOffDisabledColor = MaterialColor.grey.lighten2
				trackOffDisabledColor = MaterialColor.grey.lighten3
			case .default:
				buttonOnColor = MaterialColor.blue.lighten1
				trackOnColor = MaterialColor.blue.lighten2.withAlphaComponent(0.5)
				buttonOffColor = MaterialColor.blueGrey.lighten3
				trackOffColor = MaterialColor.blueGrey.lighten4.withAlphaComponent(0.5)
				buttonOnDisabledColor = MaterialColor.grey.darken3
				trackOnDisabledColor = MaterialColor.grey.lighten1.withAlphaComponent(0.2)
				buttonOffDisabledColor = MaterialColor.grey.darken3
				trackOffDisabledColor = MaterialColor.grey.lighten1.withAlphaComponent(0.2)
			}
		}
	}
	
	/// MaterialSwitch size.
	open var switchSize: MaterialSwitchSize = .default {
		didSet {
			switch switchSize {
			case .small:
				trackThickness = 13
				buttonDiameter = 18
				frame = CGRect(x: 0, y: 0, width: 30, height: 25)
			case .default:
				trackThickness = 17
				buttonDiameter = 24
				frame = CGRect(x: 0, y: 0, width: 40, height: 30)
			case .large:
				trackThickness = 23
				buttonDiameter = 31
				frame = CGRect(x: 0, y: 0, width: 50, height: 40)
			}
		}
	}
	
	open override var frame: CGRect {
		didSet {
			layoutSwitch()
		}
	}
	
	open override var bounds: CGRect {
		didSet {
			layoutSwitch()
		}
	}
	
	/**
	An initializer that initializes the object with a NSCoder object.
	- Parameter aDecoder: A NSCoder instance.
	*/
	public required init?(coder aDecoder: NSCoder) {
		trackLayer = CAShapeLayer()
		button = FabButton()
		super.init(coder: aDecoder)
		prepareTrack()
		prepareButton()
		prepareSwitchSize(.default)
		prepareSwitchStyle(.lightContent)
		prepareSwitchState(.off)
	}
	
	/**
	An initializer that initializes the object with a CGRect object.
	If AutoLayout is used, it is better to initilize the instance
	using the init(state:style:size:) initializer, or set the CGRect
	to CGRectNull.
	- Parameter frame: A CGRect instance.
	*/
	public override init(frame: CGRect) {
		trackLayer = CAShapeLayer()
		button = FabButton()
		super.init(frame: frame)
		prepareTrack()
		prepareButton()
		prepareSwitchSize(.default)
		prepareSwitchStyle(.lightContent)
		prepareSwitchState(.off)
	}
	
	/**
	An initializer that sets the state, style, and size of the MaterialSwitch instance.
	- Parameter state: A MaterialSwitchState value.
	- Parameter style: A MaterialSwitchStyle value.
	- Parameter size: A MaterialSwitchSize value.
	*/
	public init(state: MaterialSwitchState = .off, style: MaterialSwitchStyle = .default, size: MaterialSwitchSize = .default) {
		trackLayer = CAShapeLayer()
		button = FabButton()
		super.init(frame: CGRect.null)
		prepareTrack()
		prepareButton()
		prepareSwitchSize(size)
		prepareSwitchStyle(style)
		prepareSwitchState(state)
	}
	
	open override func willMove(toSuperview newSuperview: UIView?) {
		super.willMove(toSuperview: newSuperview)
		styleForState(internalSwitchState)
	}
	
	open override var intrinsicContentSize : CGSize {
		switch switchSize {
		case .small:
			return CGSize(width: 30, height: 25)
		case .default:
			return CGSize(width: 40, height: 30)
		case .large:
			return CGSize(width: 50, height: 40)
		}
	}
	
	/**
	Toggle the MaterialSwitch state, if On will be Off, and if Off will be On.
	- Parameter completion: An Optional completion block.
	*/
	open func toggle(_ completion: ((_ control: MaterialSwitch) -> Void)? = nil) {
		setSwitchState(.on == internalSwitchState ? .off : .on, animated: true, completion: completion)
	}
	
	/**
	Sets the switch on or off.
	- Parameter on: A bool of whether the switch should be in the on state or not.
	- Parameter animated: A Boolean indicating to set the animation or not.
	*/
	open func setOn(_ on: Bool, animated: Bool, completion: ((_ control: MaterialSwitch) -> Void)? = nil) {
		setSwitchState(on ? .on : .off, animated: animated, completion: completion)
	}
	
	/**
	Set the switchState property with an option to animate.
	- Parameter state: The MaterialSwitchState to set.
	- Parameter animated: A Boolean indicating to set the animation or not.
	- Parameter completion: An Optional completion block.
	*/
	open func setSwitchState(_ state: MaterialSwitchState, animated: Bool = true, completion: ((_ control: MaterialSwitch) -> Void)? = nil) {
		if isEnabled && internalSwitchState != state {
			internalSwitchState = state
			if animated {
				animateToState(state) { [weak self] _ in
					if let s: MaterialSwitch = self {
						s.sendActions(for: .valueChanged)
						completion?(s)
						s.delegate?.materialSwitchStateChanged(s)
					}
				}
			} else {
				button.x = .on == state ? self.onPosition : self.offPosition
				styleForState(state)
				sendActions(for: .valueChanged)
				completion?(self)
				delegate?.materialSwitchStateChanged(self)
			}
		}
	}
	
	/**
	Handle the TouchUpOutside and TouchCancel events.
	- Parameter sender: A UIButton.
	- Parameter event: A UIEvent.
	*/
	@objc(handleTouchUpOutsideOrCanceled:event:)
	internal func handleTouchUpOutsideOrCanceled(_ sender: FabButton, event: UIEvent) {
		if let v: UITouch = event.touches(for: sender)?.first {
			let q: CGFloat = sender.x + v.location(in: sender).x - v.previousLocation(in: sender).x
			setSwitchState(q > (width - button.width) / 2 ? .on : .off, animated: true)
		}
	}
	
	/// Handles the TouchUpInside event.
	internal func handleTouchUpInside() {
		toggle()
	}
	
	/**
	Handle the TouchDragInside event.
	- Parameter sender: A UIButton.
	- Parameter event: A UIEvent.
	*/
	@objc(handleTouchDragInside:event:)
	internal func handleTouchDragInside(_ sender: FabButton, event: UIEvent) {
		if let v = event.touches(for: sender)?.first {
			let q: CGFloat = max(min(sender.x + v.location(in: sender).x - v.previousLocation(in: sender).x, onPosition), offPosition)
			if q != sender.x {
				sender.x = q
			}
		}
	}
	
	open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		if true == trackLayer.frame.contains(layer.convert(touches.first!.location(in: self), from: layer)) {
			setOn(.on != internalSwitchState, animated: true)
		}
	}
	
	/// Prepares the track.
	fileprivate func prepareTrack() {
		layer.addSublayer(trackLayer)
	}
	
	/// Prepares the button.
	fileprivate func prepareButton() {
		button.pulseAnimation = .none
		button.addTarget(self, action: #selector(handleTouchUpInside), for: .touchUpInside)
		button.addTarget(self, action: #selector(handleTouchDragInside), for: .touchDragInside)
		button.addTarget(self, action: #selector(handleTouchUpOutsideOrCanceled), for: .touchCancel)
		button.addTarget(self, action: #selector(handleTouchUpOutsideOrCanceled), for: .touchUpOutside)
		addSubview(button)
	}
	
	/**
	Prepares the switchState property. This is used mainly to allow
	init to set the state value and have an effect.
	- Parameter state: The MaterialSwitchState to set.
	*/
	fileprivate func prepareSwitchState(_ state: MaterialSwitchState) {
		setSwitchState(state, animated: false)
	}
	
	/**
	Prepares the switchStyle property. This is used mainly to allow
	init to set the state value and have an effect.
	- Parameter style: The MaterialSwitchStyle to set.
	*/
	fileprivate func prepareSwitchStyle(_ style: MaterialSwitchStyle) {
		switchStyle = style
	}
	
	/**
	Prepares the switchSize property. This is used mainly to allow
	init to set the size value and have an effect.
	- Parameter size: The MaterialSwitchSize to set.
	*/
	fileprivate func prepareSwitchSize(_ size: MaterialSwitchSize) {
		switchSize = size
	}
	
	/**
	Updates the style based on the state.
	- Parameter state: The MaterialSwitchState to set the style to.
	*/
	fileprivate func styleForState(_ state: MaterialSwitchState) {
		if isEnabled {
			updateColorForState(state)
		} else {
			updateColorForDisabledState(state)
		}
	}
	
	/**
	Updates the coloring for the enabled state.
	- Parameter state: MaterialSwitchState.
	*/
	fileprivate func updateColorForState(_ state: MaterialSwitchState) {
		if .on == state {
			button.backgroundColor = buttonOnColor
			trackLayer.backgroundColor = trackOnColor.cgColor
		} else {
			button.backgroundColor = buttonOffColor
			trackLayer.backgroundColor = trackOffColor.cgColor
		}
	}
	
	/**
	Updates the coloring for the disabled state.
	- Parameter state: MaterialSwitchState.
	*/
	fileprivate func updateColorForDisabledState(_ state: MaterialSwitchState) {
		if .on == state {
			button.backgroundColor = buttonOnDisabledColor
			trackLayer.backgroundColor = trackOnDisabledColor.cgColor
		} else {
			button.backgroundColor = buttonOffDisabledColor
			trackLayer.backgroundColor = trackOffDisabledColor.cgColor
		}
	}
	
	/// Laout the button and track views.
	fileprivate func layoutSwitch() {
		var w: CGFloat = 0
		switch switchSize {
		case .small:
			w = 30
		case .default:
			w = 40
		case .large:
			w = 50
		}
		
		let px: CGFloat = (width - w) / 2
		
		trackLayer.frame = CGRect(x: px, y: (height - trackThickness) / 2, width: w, height: trackThickness)
		trackLayer.cornerRadius = min(trackLayer.frame.height, trackLayer.frame.width) / 2
		
		button.frame = CGRect(x: px, y: (height - buttonDiameter) / 2, width: buttonDiameter, height: buttonDiameter)
		onPosition = width - px - buttonDiameter
		offPosition = px
		
		if .on == internalSwitchState {
			button.x = onPosition
		}
	}
	
	/**
	Set the switchState property with an animate.
	- Parameter state: The MaterialSwitchState to set.
	- Parameter completion: An Optional completion block.
	*/
	fileprivate func animateToState(_ state: MaterialSwitchState, completion: ((_ control: MaterialSwitch) -> Void)? = nil) {
		isUserInteractionEnabled = false
		UIView.animate(withDuration: 0.15,
			delay: 0.05,
			options: UIViewAnimationOptions(),
			animations: { [weak self] in
				if let s: MaterialSwitch = self {
					s.button.x = .on == state ? s.onPosition + s.bounceOffset : s.offPosition - s.bounceOffset
					s.styleForState(state)
				}
			}) { [weak self] _ in
				UIView.animate(withDuration: 0.15,
					animations: { [weak self] in
						if let s: MaterialSwitch = self {
							s.button.x = .on == state ? s.onPosition : s.offPosition
						}
					}, completion: { [weak self] _ in
						if let s: MaterialSwitch = self {
							s.isUserInteractionEnabled = true
							completion?(s)
						}
					}) 
			}
	}
}
