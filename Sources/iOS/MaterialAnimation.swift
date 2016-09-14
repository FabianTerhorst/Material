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

@objc(MaterialAnimationDelegate)
public protocol MaterialAnimationDelegate : MaterialDelegate {
	@objc optional func materialAnimationDidStart(_ animation: CAAnimation)
	@objc optional func materialAnimationDidStop(_ animation: CAAnimation, finished flag: Bool)
}

public typealias MaterialAnimationFillModeType = String

public enum MaterialAnimationFillMode {
	case forwards
	case backwards
	case both
	case removed
}

/**
	:name:	MaterialAnimationFillModeToValue
*/
public func MaterialAnimationFillModeToValue(_ mode: MaterialAnimationFillMode) -> MaterialAnimationFillModeType {
	switch mode {
	case .forwards:
		return kCAFillModeForwards
	case .backwards:
		return kCAFillModeBackwards
	case .both:
		return kCAFillModeBoth
	case .removed:
		return kCAFillModeRemoved
	}
}

public typealias MaterialAnimationDelayCancelBlock = (_ cancel : Bool) -> Void

public struct MaterialAnimation {
	/// Delay helper method.
	public static func delay(_ time: TimeInterval, completion: @escaping ()-> Void) ->  MaterialAnimationDelayCancelBlock? {
		
		func dispatch_later(_ completion: @escaping ()-> Void) {
			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: completion)
		}
		
		var cancelable: MaterialAnimationDelayCancelBlock?
		
		let delayed: MaterialAnimationDelayCancelBlock = { (cancel: Bool) in
			if !cancel {
				DispatchQueue.main.async(execute: completion)
			}
			cancelable = nil
		}
		
		cancelable = delayed
		
		dispatch_later {
			cancelable?(false)
		}
		
		return cancelable;
	}
	
	/**
	:name:	delayCancel
	*/
	public static func delayCancel(_ completion: MaterialAnimationDelayCancelBlock?) {
		completion?(true)
	}

	
	/**
	:name:	animationDisabled
	*/
	public static func animationDisabled(_ animations: (() -> Void)) {
		animateWithDuration(0, animations: animations)
	}
	
	/**
	:name:	animateWithDuration
	*/
	public static func animateWithDuration(_ duration: CFTimeInterval, animations: (() -> Void), completion: (() -> Void)? = nil) {
		CATransaction.begin()
		CATransaction.setAnimationDuration(duration)
		CATransaction.setCompletionBlock(completion)
		CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
		animations()
		CATransaction.commit()
	}
	
	/**
	:name:	animationGroup
	*/
	public static func animationGroup(_ animations: Array<CAAnimation>, duration: CFTimeInterval = 0.5) -> CAAnimationGroup {
		let group: CAAnimationGroup = CAAnimationGroup()
		group.fillMode = MaterialAnimationFillModeToValue(.forwards)
		group.isRemovedOnCompletion = false
		group.animations = animations
		group.duration = duration
		group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		return group
	}
	
	/**
	:name:	animateWithDelay
	*/
	public static func animateWithDelay(delay d: CFTimeInterval, duration: CFTimeInterval, animations: @escaping (() -> Void), completion: (() -> Void)? = nil) {
		delay(d) {
			animateWithDuration(duration, animations: animations, completion: completion)
		}
	}
}
