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
import AVFoundation

public enum CaptureMode {
	case photo
	case video
}

@objc(CaptureViewDelegate)
public protocol CaptureViewDelegate : MaterialDelegate {
	/**
	:name:	captureViewDidStartRecordTimer
	*/
	@objc optional func captureViewDidStartRecordTimer(_ captureView: CaptureView)
	
	/**
	:name:	captureViewDidUpdateRecordTimer
	*/
	@objc optional func captureViewDidUpdateRecordTimer(_ captureView: CaptureView, hours: Int, minutes: Int, seconds: Int)
	
	/**
	:name:	captureViewDidStopRecordTimer
	*/
	@objc optional func captureViewDidStopRecordTimer(_ captureView: CaptureView, hours: Int, minutes: Int, seconds: Int)
	
	/**
	:name:	captureViewDidTapToFocusAtPoint
	*/
	@objc optional func captureViewDidTapToFocusAtPoint(_ captureView: CaptureView, point: CGPoint)
	
	/**
	:name:	captureViewDidTapToExposeAtPoint
	*/
	@objc optional func captureViewDidTapToExposeAtPoint(_ captureView: CaptureView, point: CGPoint)
	
	/**
	:name:	captureViewDidTapToResetAtPoint
	*/
	@objc optional func captureViewDidTapToResetAtPoint(_ captureView: CaptureView, point: CGPoint)
	
	/**
	:name:	captureViewDidPressFlashButton
	*/
	@objc optional func captureViewDidPressFlashButton(_ captureView: CaptureView, button: UIButton)
	
	/**
	:name:	captureViewDidPressSwitchCamerasButton
	*/
	@objc optional func captureViewDidPressSwitchCamerasButton(_ captureView: CaptureView, button: UIButton)
	
	/**
	:name:	captureViewDidPressCaptureButton
	*/
	@objc optional func captureViewDidPressCaptureButton(_ captureView: CaptureView, button: UIButton)
	
	/**
	:name:	captureViewDidPressCameraButton
	*/
	@objc optional func captureViewDidPressCameraButton(_ captureView: CaptureView, button: UIButton)
	
	/**
	:name:	captureViewDidPressVideoButton
	*/
	@objc optional func captureViewDidPressVideoButton(_ captureView: CaptureView, button: UIButton)
}

open class CaptureView : MaterialView, UIGestureRecognizerDelegate {
	/**
	:name:	timer
	*/
	fileprivate var timer: Timer?
	
	/**
	:name:	tapToFocusGesture
	*/
	fileprivate var tapToFocusGesture: UITapGestureRecognizer?
	
	/**
	:name:	tapToExposeGesture
	*/
	fileprivate var tapToExposeGesture: UITapGestureRecognizer?
	
	/**
	:name:	tapToResetGesture
	*/
	fileprivate var tapToResetGesture: UITapGestureRecognizer?
	
	/**
	:name:	captureMode
	*/
	open lazy var captureMode: CaptureMode = .video
	
	/**
	:name:	tapToFocusEnabled
	*/
	@IBInspectable open var tapToFocusEnabled: Bool = false {
		didSet {
			if tapToFocusEnabled {
				tapToResetEnabled = true
				prepareFocusLayer()
				prepareTapGesture(&tapToFocusGesture, numberOfTapsRequired: 1, numberOfTouchesRequired: 1, selector: #selector(handleTapToFocusGesture))
				if let v: UITapGestureRecognizer = tapToExposeGesture {
					tapToFocusGesture!.require(toFail: v)
				}
			} else {
				removeTapGesture(&tapToFocusGesture)
				focusLayer?.removeFromSuperlayer()
				focusLayer = nil
			}
		}
	}
	
	/**
	:name:	tapToExposeEnabled
	*/
	@IBInspectable open var tapToExposeEnabled: Bool = false {
		didSet {
			if tapToExposeEnabled {
				tapToResetEnabled = true
				prepareExposureLayer()
				prepareTapGesture(&tapToExposeGesture, numberOfTapsRequired: 2, numberOfTouchesRequired: 1, selector: #selector(handleTapToExposeGesture))
				if let v: UITapGestureRecognizer = tapToFocusGesture {
					v.require(toFail: tapToExposeGesture!)
				}
			} else {
				removeTapGesture(&tapToExposeGesture)
				exposureLayer?.removeFromSuperlayer()
				exposureLayer = nil
			}
		}
	}
	
	/**
	:name:	tapToResetEnabled
	*/
	@IBInspectable open var tapToResetEnabled: Bool = false {
		didSet {
			if tapToResetEnabled {
				prepareResetLayer()
				prepareTapGesture(&tapToResetGesture, numberOfTapsRequired: 2, numberOfTouchesRequired: 2, selector: #selector(handleTapToResetGesture))
				if let v: UITapGestureRecognizer = tapToFocusGesture {
					v.require(toFail: tapToResetGesture!)
				}
				if let v: UITapGestureRecognizer = tapToExposeGesture {
					v.require(toFail: tapToResetGesture!)
				}
			} else {
				removeTapGesture(&tapToResetGesture)
				resetLayer?.removeFromSuperlayer()
				resetLayer = nil
			}
		}
	}
	
	/**
	:name:	contentInsets
	*/
	open var contentInsetPreset: MaterialEdgeInset = .none {
		didSet {
			contentInset = MaterialEdgeInsetToValue(contentInsetPreset)
		}
	}
	
	/**
	:name:	contentInset
	*/
	open var contentInset: UIEdgeInsets = MaterialEdgeInsetToValue(.square4) {
		didSet {
			reloadView()
		}
	}
	
	/**
	:name:	previewView
	*/
	open fileprivate(set) lazy var previewView: CapturePreview = CapturePreview()
	
	/**
	:name:	capture
	*/
	open fileprivate(set) lazy var captureSession: CaptureSession = CaptureSession()
	
	/**
	:name:	focusLayer
	*/
	open fileprivate(set) var focusLayer: MaterialLayer?
	
	/**
	:name:	exposureLayer
	*/
	open fileprivate(set) var exposureLayer: MaterialLayer?
	
	/**
	:name:	resetLayer
	*/
	open fileprivate(set) var resetLayer: MaterialLayer?
	
	/**
	:name:	cameraButton
	*/
	open var cameraButton: UIButton? {
		didSet {
			if let v: UIButton = cameraButton {
				v.addTarget(self, action: #selector(handleCameraButton), for: .touchUpInside)
			}
			reloadView()
		}
	}
	
	/**
	:name:	captureButton
	*/
	open var captureButton: UIButton? {
		didSet {
			if let v: UIButton = captureButton {
				v.addTarget(self, action: #selector(handleCaptureButton), for: .touchUpInside)
			}
			reloadView()
		}
	}

	
	/**
	:name:	videoButton
	*/
	open var videoButton: UIButton? {
		didSet {
			if let v: UIButton = videoButton {
				v.addTarget(self, action: #selector(handleVideoButton), for: .touchUpInside)
			}
			reloadView()
		}
	}
	
	/**
	:name:	switchCamerasButton
	*/
	open var switchCamerasButton: UIButton? {
		didSet {
			if let v: UIButton = switchCamerasButton {
				v.addTarget(self, action: #selector(handleSwitchCamerasButton), for: .touchUpInside)
			}
		}
	}
	
	/**
	:name:	flashButton
	*/
	open var flashButton: UIButton? {
		didSet {
			if let v: UIButton = flashButton {
				v.addTarget(self, action: #selector(handleFlashButton), for: .touchUpInside)
			}
		}
	}
	
	/**
	:name:	init
	*/
	public convenience init() {
		self.init(frame: CGRect.zero)
	}
	
	/**
	:name:	layoutSubviews
	*/
	open override func layoutSubviews() {
		super.layoutSubviews()
		previewView.frame = bounds
		
		if let v: UIButton = cameraButton {
			v.frame.origin.y = bounds.height - contentInset.bottom - v.bounds.height
			v.frame.origin.x = contentInset.left
		}
		if let v: UIButton = captureButton {
			v.frame.origin.y = bounds.height - contentInset.bottom - v.bounds.height
			v.frame.origin.x = (bounds.width - v.bounds.width) / 2
		}
		if let v: UIButton = videoButton {
			v.frame.origin.y = bounds.height - contentInset.bottom - v.bounds.height
			v.frame.origin.x = bounds.width - v.bounds.width - contentInset.right
		}
		if let v: AVCaptureConnection = (previewView.layer as! AVCaptureVideoPreviewLayer).connection {
			v.videoOrientation = captureSession.videoOrientation
		}
	}
	
	/**
	:name:	prepareView
	*/
	open override func prepareView() {
		super.prepareView()
		backgroundColor = MaterialColor.black
		preparePreviewView()
	}
	
	/**
	:name:	reloadView
	*/
	open func reloadView() {
		// clear constraints so new ones do not conflict
		removeConstraints(constraints)
		for v in subviews {
			v.removeFromSuperview()
		}
		
		insertSubview(previewView, at: 0)
		
		if let v: UIButton = captureButton {
			insertSubview(v, at: 1)
		}
		
		if let v: UIButton = cameraButton {
			insertSubview(v, at: 2)
		}
		
		if let v: UIButton = videoButton {
			insertSubview(v, at: 3)
		}
	}
	
	/**
	:name:	startTimer
	*/
	internal func startTimer() {
		timer?.invalidate()
		timer = Timer(timeInterval: 0.5, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
		RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
		(delegate as? CaptureViewDelegate)?.captureViewDidStartRecordTimer?(self)
	}
	
	/**
	:name:	updateTimer
	*/
	internal func updateTimer() {
		let duration: CMTime = captureSession.recordedDuration
		let time: Double = CMTimeGetSeconds(duration)
		let hours: Int = Int(time / 3600)
		let minutes: Int = Int((time / 60).truncatingRemainder(dividingBy: 60))
		let seconds: Int = Int(time.truncatingRemainder(dividingBy: 60))
		(delegate as? CaptureViewDelegate)?.captureViewDidUpdateRecordTimer?(self, hours: hours, minutes: minutes, seconds: seconds)
	}
	
	/**
	:name:	stopTimer
	*/
	internal func stopTimer() {
		let duration: CMTime = captureSession.recordedDuration
		let time: Double = CMTimeGetSeconds(duration)
		let hours: Int = Int(time / 3600)
		let minutes: Int = Int((time / 60).truncatingRemainder(dividingBy: 60))
		let seconds: Int = Int(time.truncatingRemainder(dividingBy: 60))
		timer?.invalidate()
		timer = nil
		(delegate as? CaptureViewDelegate)?.captureViewDidStopRecordTimer?(self, hours: hours, minutes: minutes, seconds: seconds)
	}
	
	/**
	:name:	handleFlashButton
	*/
	internal func handleFlashButton(_ button: UIButton) {
		(delegate as? CaptureViewDelegate)?.captureViewDidPressFlashButton?(self, button: button)
	}
	
	/**
	:name:	handleSwitchCamerasButton
	*/
	internal func handleSwitchCamerasButton(_ button: UIButton) {
		captureSession.switchCameras()
		(delegate as? CaptureViewDelegate)?.captureViewDidPressSwitchCamerasButton?(self, button: button)
	}
	
	/**
	:name:	handleCaptureButton
	*/
	internal func handleCaptureButton(_ button: UIButton) {
		if .photo == captureMode {
			captureSession.captureStillImage()
		} else if .video == captureMode {
			if captureSession.isRecording {
				captureSession.stopRecording()
				stopTimer()
			} else {
				captureSession.startRecording()
				startTimer()
			}
		}
		(delegate as? CaptureViewDelegate)?.captureViewDidPressCaptureButton?(self, button: button)
	}
	
	/**
	:name:	handleCameraButton
	*/
	internal func handleCameraButton(_ button: UIButton) {
		captureMode = .photo
		(delegate as? CaptureViewDelegate)?.captureViewDidPressCameraButton?(self, button: button)
	}
	
	/**
	:name:	handleVideoButton
	*/
	internal func handleVideoButton(_ button: UIButton) {
		captureMode = .video
		(delegate as? CaptureViewDelegate)?.captureViewDidPressVideoButton?(self, button: button)
	}
	
	/**
	:name:	handleTapToFocusGesture
	*/
	@objc(handleTapToFocusGesture:)
	internal func handleTapToFocusGesture(_ recognizer: UITapGestureRecognizer) {
		if tapToFocusEnabled && captureSession.cameraSupportsTapToFocus {
			let point: CGPoint = recognizer.location(in: self)
			captureSession.focusAtPoint(previewView.captureDevicePointOfInterestForPoint(point))
			animateTapLayer(layer: focusLayer!, point: point)
			(delegate as? CaptureViewDelegate)?.captureViewDidTapToFocusAtPoint?(self, point: point)
		}
	}
	
	/**
	:name:	handleTapToExposeGesture
	*/
	@objc(handleTapToExposeGesture:)
	internal func handleTapToExposeGesture(_ recognizer: UITapGestureRecognizer) {
		if tapToExposeEnabled && captureSession.cameraSupportsTapToExpose {
			let point: CGPoint = recognizer.location(in: self)
			captureSession.exposeAtPoint(previewView.captureDevicePointOfInterestForPoint(point))
			animateTapLayer(layer: exposureLayer!, point: point)
			(delegate as? CaptureViewDelegate)?.captureViewDidTapToExposeAtPoint?(self, point: point)
		}
	}
	
	/**
	:name:	handleTapToResetGesture
	*/
	@objc(handleTapToResetGesture:)
	internal func handleTapToResetGesture(_ recognizer: UITapGestureRecognizer) {
		if tapToResetEnabled {
			captureSession.resetFocusAndExposureModes()
			let point: CGPoint = previewView.pointForCaptureDevicePointOfInterest(CGPoint(x: 0.5, y: 0.5))
			animateTapLayer(layer: resetLayer!, point: point)
			(delegate as? CaptureViewDelegate)?.captureViewDidTapToResetAtPoint?(self, point: point)
		}
	}
	
	/**
	:name:	prepareTapGesture
	*/
	fileprivate func prepareTapGesture(_ gesture: inout UITapGestureRecognizer?, numberOfTapsRequired: Int, numberOfTouchesRequired: Int, selector: Selector) {
		removeTapGesture(&gesture)
		gesture = UITapGestureRecognizer(target: self, action: selector)
		gesture!.delegate = self
		gesture!.numberOfTapsRequired = numberOfTapsRequired
		gesture!.numberOfTouchesRequired = numberOfTouchesRequired
		addGestureRecognizer(gesture!)
	}
	
	/**
	:name:	removeTapToFocusGesture
	*/
	fileprivate func removeTapGesture(_ gesture: inout UITapGestureRecognizer?) {
		if let v: UIGestureRecognizer = gesture {
			removeGestureRecognizer(v)
			gesture = nil
		}
	}
	
	/**
	:name:	preparePreviewView
	*/
	fileprivate func preparePreviewView() {
		(previewView.layer as! AVCaptureVideoPreviewLayer).session = captureSession.session
		captureSession.startSession()
	}
	
	/**
	:name:	prepareFocusLayer
	*/
	fileprivate func prepareFocusLayer() {
		if nil == focusLayer {
			focusLayer = MaterialLayer(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
			focusLayer!.isHidden = true
			focusLayer!.borderWidth = 2
			focusLayer!.borderColor = MaterialColor.white.cgColor
			previewView.layer.addSublayer(focusLayer!)
		}
	}
	
	/**
	:name:	prepareExposureLayer
	*/
	fileprivate func prepareExposureLayer() {
		if nil == exposureLayer {
			exposureLayer = MaterialLayer(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
			exposureLayer!.isHidden = true
			exposureLayer!.borderWidth = 2
			exposureLayer!.borderColor = MaterialColor.yellow.darken1.cgColor
			previewView.layer.addSublayer(exposureLayer!)
		}
	}
	
	/**
	:name:	prepareResetLayer
	*/
	fileprivate func prepareResetLayer() {
		if nil == resetLayer {
			resetLayer = MaterialLayer(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
			resetLayer!.isHidden = true
			resetLayer!.borderWidth = 2
			resetLayer!.borderColor = MaterialColor.red.accent1.cgColor
			previewView.layer.addSublayer(resetLayer!)
		}
	}
	
	/**
	:name:	animateTapLayer
	*/
	fileprivate func animateTapLayer(layer v: MaterialLayer, point: CGPoint) {
		MaterialAnimation.animationDisabled {
			v.transform = CATransform3DIdentity
			v.position = point
			v.isHidden = false
		}
		MaterialAnimation.animateWithDuration(0.25, animations: {
			v.transform = CATransform3DMakeScale(0.5, 0.5, 1)
		}) {
			MaterialAnimation.delay(0.4) {
				MaterialAnimation.animationDisabled {
					v.isHidden = true
				}
			}
		}
	}
}
