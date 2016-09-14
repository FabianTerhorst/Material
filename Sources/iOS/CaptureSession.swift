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

private var CaptureSessionAdjustingExposureContext: UInt8 = 1

public enum CaptureSessionPreset {
	case presetPhoto
	case presetHigh
	case presetMedium
	case presetLow
	case preset352x288
	case preset640x480
	case preset1280x720
	case preset1920x1080
	case preset3840x2160
	case presetiFrame960x540
	case presetiFrame1280x720
	case presetInputPriority
}

/**
	:name:	CaptureSessionPresetToString
*/
public func CaptureSessionPresetToString(_ preset: CaptureSessionPreset) -> String {
	switch preset {
	case .presetPhoto:
		return AVCaptureSessionPresetPhoto
	case .presetHigh:
		return AVCaptureSessionPresetHigh
	case .presetMedium:
		return AVCaptureSessionPresetMedium
	case .presetLow:
		return AVCaptureSessionPresetLow
	case .preset352x288:
		return AVCaptureSessionPreset352x288
	case .preset640x480:
		return AVCaptureSessionPreset640x480
	case .preset1280x720:
		return AVCaptureSessionPreset1280x720
	case .preset1920x1080:
		return AVCaptureSessionPreset1920x1080
	case .preset3840x2160:
		if #available(iOS 9.0, *) {
			return AVCaptureSessionPreset3840x2160
		} else {
			return AVCaptureSessionPresetHigh
		}
	case .presetiFrame960x540:
		return AVCaptureSessionPresetiFrame960x540
	case .presetiFrame1280x720:
		return AVCaptureSessionPresetiFrame1280x720
	case .presetInputPriority:
		return AVCaptureSessionPresetInputPriority
	}
}

@objc(CaptureSessionDelegate)
public protocol CaptureSessionDelegate {
	/**
	:name:	captureSessionFailedWithError
	*/
	@objc optional func captureSessionFailedWithError(_ capture: CaptureSession, error: NSError)
	
	/**
	:name:	captureSessionDidSwitchCameras
	*/
	@objc optional func captureSessionDidSwitchCameras(_ capture: CaptureSession, position: AVCaptureDevicePosition)
	
	/**
	:name:	captureSessionWillSwitchCameras
	*/
	@objc optional func captureSessionWillSwitchCameras(_ capture: CaptureSession, position: AVCaptureDevicePosition)
	
	/**
	:name:	captureStillImageAsynchronously
	*/
	@objc optional func captureStillImageAsynchronously(_ capture: CaptureSession, image: UIImage)
	
	/**
	:name:	captureStillImageAsynchronouslyFailedWithError
	*/
	@objc optional func captureStillImageAsynchronouslyFailedWithError(_ capture: CaptureSession, error: NSError)
	
	/**
	:name:	captureCreateMovieFileFailedWithError
	*/
	@objc optional func captureCreateMovieFileFailedWithError(_ capture: CaptureSession, error: NSError)
	
	/**
	:name:	captureMovieFailedWithError
	*/
	@objc optional func captureMovieFailedWithError(_ capture: CaptureSession, error: NSError)
	
	/**
	:name:	captureDidStartRecordingToOutputFileAtURL
	*/
	@objc optional func captureDidStartRecordingToOutputFileAtURL(_ capture: CaptureSession, captureOutput: AVCaptureFileOutput, fileURL: URL, fromConnections connections: [AnyObject])
	
	/**
	:name:	captureDidFinishRecordingToOutputFileAtURL
	*/
	@objc optional func captureDidFinishRecordingToOutputFileAtURL(_ capture: CaptureSession, captureOutput: AVCaptureFileOutput, outputFileURL: URL, fromConnections connections: [AnyObject], error: NSError!)
}

@objc(CaptureSession)
open class CaptureSession : NSObject, AVCaptureFileOutputRecordingDelegate {
	/**
	:name:	sessionQueue
	*/
	fileprivate lazy var sessionQueue: DispatchQueue = DispatchQueue(label: "io.material.CaptureSession", attributes: [])
	
	/**
	:name:	activeVideoInput
	*/
	fileprivate var activeVideoInput: AVCaptureDeviceInput?
	
	/**
	:name:	activeAudioInput
	*/
	fileprivate var activeAudioInput: AVCaptureDeviceInput?
	
	/**
	:name:	imageOutput
	*/
	fileprivate lazy var imageOutput: AVCaptureStillImageOutput = AVCaptureStillImageOutput()
	
	/**
	:name:	movieOutput
	*/
	fileprivate lazy var movieOutput: AVCaptureMovieFileOutput = AVCaptureMovieFileOutput()
	
	/**
	:name:	movieOutputURL
	*/
	fileprivate var movieOutputURL: URL?
	
	/**
	:name: session
	*/
	internal lazy var session: AVCaptureSession = AVCaptureSession()
	
	/**
	:name:	isRunning
	*/
	open fileprivate(set) lazy var isRunning: Bool = false
	
	/**
	:name:	isRecording
	*/
	open fileprivate(set) lazy var isRecording: Bool = false
	
	/**
	:name:	recordedDuration
	*/
	open var recordedDuration: CMTime {
		return movieOutput.recordedDuration
	}
	
	/**
	:name:	activeCamera
	*/
	open var activeCamera: AVCaptureDevice? {
		return activeVideoInput?.device
	}
	
	/**
	:name:	inactiveCamera
	*/
	open var inactiveCamera: AVCaptureDevice? {
		var device: AVCaptureDevice?
		if 1 < cameraCount {
			if activeCamera?.position == .back {
				device = cameraWithPosition(.front)
			} else {
				device = cameraWithPosition(.back)
			}
		}
		return device
	}
	
	/**
	:name:	cameraCount
	*/
	open var cameraCount: Int {
		return AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo).count
	}
	
	/**
	:name:	canSwitchCameras
	*/
	open var canSwitchCameras: Bool {
		return 1 < cameraCount
	}
	
	/**
	:name:	caneraSupportsTapToFocus
	*/
	open var cameraSupportsTapToFocus: Bool {
		return nil == activeCamera ? false : activeCamera!.isFocusPointOfInterestSupported
	}
	
	/**
	:name:	cameraSupportsTapToExpose
	*/
	open var cameraSupportsTapToExpose: Bool {
		return nil == activeCamera ? false : activeCamera!.isExposurePointOfInterestSupported
	}
	
	/**
	:name:	cameraHasFlash
	*/
	open var cameraHasFlash: Bool {
		return nil == activeCamera ? false : activeCamera!.hasFlash
	}
	
	/**
	:name:	cameraHasTorch
	*/
	open var cameraHasTorch: Bool {
		return nil == activeCamera ? false : activeCamera!.hasTorch
	}
	
	/**
	:name:	cameraPosition
	*/
	open var cameraPosition: AVCaptureDevicePosition? {
		return activeCamera?.position
	}
	
	/**
	:name:	focusMode
	*/
	open var focusMode: AVCaptureFocusMode {
		get {
			return activeCamera!.focusMode
		}
		set(value) {
			var error: NSError?
			if isFocusModeSupported(focusMode) {
				do {
					let device: AVCaptureDevice = activeCamera!
					try device.lockForConfiguration()
					device.focusMode = value
					device.unlockForConfiguration()
				} catch let e as NSError {
					error = e
				}
			} else {
				var userInfo: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
				userInfo[NSLocalizedDescriptionKey] = "[Material Error: Unsupported focusMode.]" as AnyObject?
				userInfo[NSLocalizedFailureReasonErrorKey] = "[Material Error: Unsupported focusMode.]" as AnyObject?
				error = NSError(domain: "io.cosmicmind.Material.CaptureView", code: 0001, userInfo: userInfo)
				userInfo[NSUnderlyingErrorKey] = error
			}
			if let e: NSError = error {
				delegate?.captureSessionFailedWithError?(self, error: e)
			}
		}
	}
	
	/**
	:name:	flashMode
	*/
	open var flashMode: AVCaptureFlashMode {
		get {
			return activeCamera!.flashMode
		}
		set(value) {
			var error: NSError?
			if isFlashModeSupported(flashMode) {
				do {
					let device: AVCaptureDevice = activeCamera!
					try device.lockForConfiguration()
					device.flashMode = value
					device.unlockForConfiguration()
				} catch let e as NSError {
					error = e
				}
			} else {
				var userInfo: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
				userInfo[NSLocalizedDescriptionKey] = "[Material Error: Unsupported flashMode.]" as AnyObject?
				userInfo[NSLocalizedFailureReasonErrorKey] = "[Material Error: Unsupported flashMode.]" as AnyObject?
				error = NSError(domain: "io.cosmicmind.Material.CaptureView", code: 0002, userInfo: userInfo)
				userInfo[NSUnderlyingErrorKey] = error
			}
			if let e: NSError = error {
				delegate?.captureSessionFailedWithError?(self, error: e)
			}
		}
	}
	
	/**
	:name:	torchMode
	*/
	open var torchMode: AVCaptureTorchMode {
		get {
			return activeCamera!.torchMode
		}
		set(value) {
			var error: NSError?
			if isTorchModeSupported(torchMode) {
				do {
					let device: AVCaptureDevice = activeCamera!
					try device.lockForConfiguration()
					device.torchMode = value
					device.unlockForConfiguration()
				} catch let e as NSError {
					error = e
				}
			} else {
				var userInfo: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
				userInfo[NSLocalizedDescriptionKey] = "[Material Error: Unsupported torchMode.]" as AnyObject?
				userInfo[NSLocalizedFailureReasonErrorKey] = "[Material Error: Unsupported torchMode.]" as AnyObject?
				error = NSError(domain: "io.cosmicmind.Material.CaptureView", code: 0003, userInfo: userInfo)
				userInfo[NSUnderlyingErrorKey] = error
			}
			if let e: NSError = error {
				delegate?.captureSessionFailedWithError?(self, error: e)
			}
		}
	}
	
	/// The session quality preset.
	open var sessionPreset: CaptureSessionPreset {
		didSet {
			session.sessionPreset = CaptureSessionPresetToString(sessionPreset)
		}
	}
	
	/// The capture video orientation.
	open var videoOrientation: AVCaptureVideoOrientation {
		var orientation: AVCaptureVideoOrientation
		switch UIDevice.current.orientation {
		case .portrait:
			orientation = .portrait
		case .landscapeRight:
			orientation = .landscapeLeft
		case .portraitUpsideDown:
			orientation = .portraitUpsideDown
		default:
			orientation = .landscapeRight
		}
		return orientation
	}
	
	/// A delegation property for CaptureSessionDelegate.
	open weak var delegate: CaptureSessionDelegate?
	
	/// Initializer.
	public override init() {
		sessionPreset = .presetHigh
		super.init()
		prepareSession()
	}
	
	/// Starts the session.
	open func startSession() {
		if !isRunning {
			sessionQueue.async { [weak self] in
				self?.session.startRunning()
			}
		}
	}
	
	/// Stops the session.
	open func stopSession() {
		if isRunning {
			sessionQueue.async { [weak self] in
				self?.session.stopRunning()
			}
		}
	}
	
	/// Switches the camera if possible.
	open func switchCameras() {
		if canSwitchCameras {
			do {
				if let v: AVCaptureDevicePosition = cameraPosition {
					delegate?.captureSessionWillSwitchCameras?(self, position: v)
					let videoInput: AVCaptureDeviceInput? = try AVCaptureDeviceInput(device: inactiveCamera!)
					session.beginConfiguration()
					session.removeInput(activeVideoInput)
					
					if session.canAddInput(videoInput) {
						session.addInput(videoInput)
						activeVideoInput = videoInput
					} else {
						session.addInput(activeVideoInput)
					}
					session.commitConfiguration()
					delegate?.captureSessionDidSwitchCameras?(self, position: cameraPosition!)
				}
			} catch let e as NSError {
				delegate?.captureSessionFailedWithError?(self, error: e)
			}
		}
	}
	
	/**
	:name:	isFocusModeSupported
	*/
	open func isFocusModeSupported(_ focusMode: AVCaptureFocusMode) -> Bool {
		return activeCamera!.isFocusModeSupported(focusMode)
	}
	
	/**
	:name:	isExposureModeSupported
	*/
	open func isExposureModeSupported(_ exposureMode: AVCaptureExposureMode) -> Bool {
		return activeCamera!.isExposureModeSupported(exposureMode)
	}
	
	/**
	:name:	isFlashModeSupported
	*/
	open func isFlashModeSupported(_ flashMode: AVCaptureFlashMode) -> Bool {
		return activeCamera!.isFlashModeSupported(flashMode)
	}
	
	/**
	:name:	isTorchModeSupported
	*/
	open func isTorchModeSupported(_ torchMode: AVCaptureTorchMode) -> Bool {
		return activeCamera!.isTorchModeSupported(torchMode)
	}
	
	/**
	:name:	focusAtPoint
	*/
	open func focusAtPoint(_ point: CGPoint) {
		var error: NSError?
		if cameraSupportsTapToFocus && isFocusModeSupported(.autoFocus) {
			do {
				let device: AVCaptureDevice = activeCamera!
				try device.lockForConfiguration()
				device.focusPointOfInterest = point
				device.focusMode = .autoFocus
				device.unlockForConfiguration()
			} catch let e as NSError {
				error = e
			}
		} else {
			var userInfo: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
			userInfo[NSLocalizedDescriptionKey] = "[Material Error: Unsupported focusAtPoint.]" as AnyObject?
			userInfo[NSLocalizedFailureReasonErrorKey] = "[Material Error: Unsupported focusAtPoint.]" as AnyObject?
			error = NSError(domain: "io.cosmicmind.Material.CaptureView", code: 0004, userInfo: userInfo)
			userInfo[NSUnderlyingErrorKey] = error
		}
		if let e: NSError = error {
			delegate?.captureSessionFailedWithError?(self, error: e)
		}
	}
	
	/**
	:name:	exposeAtPoint
	*/
	open func exposeAtPoint(_ point: CGPoint) {
		var error: NSError?
		if cameraSupportsTapToExpose && isExposureModeSupported(.continuousAutoExposure) {
			do {
				let device: AVCaptureDevice = activeCamera!
				try device.lockForConfiguration()
				device.exposurePointOfInterest = point
				device.exposureMode = .continuousAutoExposure
				if device.isExposureModeSupported(.locked) {
					device.addObserver(self, forKeyPath: "adjustingExposure", options: .new, context: &CaptureSessionAdjustingExposureContext)
				}
				device.unlockForConfiguration()
			} catch let e as NSError {
				error = e
			}
		} else {
			var userInfo: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
			userInfo[NSLocalizedDescriptionKey] = "[Material Error: Unsupported exposeAtPoint.]" as AnyObject?
			userInfo[NSLocalizedFailureReasonErrorKey] = "[Material Error: Unsupported exposeAtPoint.]" as AnyObject?
			error = NSError(domain: "io.cosmicmind.Material.CaptureView", code: 0005, userInfo: userInfo)
			userInfo[NSUnderlyingErrorKey] = error
		}
		if let e: NSError = error {
			delegate?.captureSessionFailedWithError?(self, error: e)
		}
	}
	
	/**
	:name:	observeValueForKeyPath
	*/
	open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if context == &CaptureSessionAdjustingExposureContext {
			let device: AVCaptureDevice = object as! AVCaptureDevice
			if !device.isAdjustingExposure && device.isExposureModeSupported(.locked) {
				(object! as AnyObject).removeObserver(self, forKeyPath: "adjustingExposure", context: &CaptureSessionAdjustingExposureContext)
				DispatchQueue.main.async {
					do {
						try device.lockForConfiguration()
						device.exposureMode = .locked
						device.unlockForConfiguration()
					} catch let e as NSError {
						self.delegate?.captureSessionFailedWithError?(self, error: e)
					}
				}
			}
		} else {
			super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
		}
	}
	
	/**
	:name:	resetFocusAndExposureModes
	*/
	open func resetFocusAndExposureModes() {
		let device: AVCaptureDevice = activeCamera!
		let canResetFocus: Bool = device.isFocusPointOfInterestSupported && device.isFocusModeSupported(.continuousAutoFocus)
		let canResetExposure: Bool = device.isExposurePointOfInterestSupported && device.isExposureModeSupported(.continuousAutoExposure)
		let centerPoint: CGPoint = CGPoint(x: 0.5, y: 0.5)
		do {
			try device.lockForConfiguration()
			if canResetFocus {
				device.focusMode = .continuousAutoFocus
				device.focusPointOfInterest = centerPoint
			}
			if canResetExposure {
				device.exposureMode = .continuousAutoExposure
				device.exposurePointOfInterest = centerPoint
			}
			device.unlockForConfiguration()
		} catch let e as NSError {
			delegate?.captureSessionFailedWithError?(self, error: e)
		}
	}
	
	/**
	:name:	captureStillImage
	*/
	/*open func captureStillImage() {
		sessionQueue.async { [weak self] in
			if let s: CaptureSession = self {
				if let v: AVCaptureConnection = s.imageOutput.connection(withMediaType: AVMediaTypeVideo) {
					v.videoOrientation = s.videoOrientation
					s.imageOutput.captureStillImageAsynchronously(from: v) { [weak self] (sampleBuffer: CMSampleBuffer?, error: NSError!) -> Void in
						if let s: CaptureSession = self {
							var captureError: NSError? = error
							if nil == captureError {
								let data: Data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
								if let image1: UIImage = UIImage(data: data) {
									if let image2: UIImage = s.adjustOrientationForImage(image1) {
										s.delegate?.captureStillImageAsynchronously?(s, image: image2)
									} else {
										var userInfo: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
										userInfo[NSLocalizedDescriptionKey] = "[Material Error: Cannot fix image orientation.]"
										userInfo[NSLocalizedFailureReasonErrorKey] = "[Material Error: Cannot fix image orientation.]"
										captureError = NSError(domain: "io.cosmicmind.Material.CaptureView", code: 0006, userInfo: userInfo)
										userInfo[NSUnderlyingErrorKey] = error
									}
								} else {
									var userInfo: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
									userInfo[NSLocalizedDescriptionKey] = "[Material Error: Cannot capture image from data.]"
									userInfo[NSLocalizedFailureReasonErrorKey] = "[Material Error: Cannot capture image from data.]"
									captureError = NSError(domain: "io.cosmicmind.Material.CaptureView", code: 0007, userInfo: userInfo)
									userInfo[NSUnderlyingErrorKey] = error
								}
							}
							
							if let e: NSError = captureError {
								s.delegate?.captureStillImageAsynchronouslyFailedWithError?(s, error: e)
							}
						}
					}
				}
			}
		}
	}*/
	
	/**
	:name:	startRecording
	*/
	open func startRecording() {
		if !isRecording {
			sessionQueue.async { [weak self] in
				if let s: CaptureSession = self {
					if let v: AVCaptureConnection = s.movieOutput.connection(withMediaType: AVMediaTypeVideo) {
						v.videoOrientation = s.videoOrientation
						v.preferredVideoStabilizationMode = .auto
					}
					if let v: AVCaptureDevice = s.activeCamera {
						if v.isSmoothAutoFocusSupported {
							do {
								try v.lockForConfiguration()
								v.isSmoothAutoFocusEnabled = true
								v.unlockForConfiguration()
							} catch let e as NSError {
								s.delegate?.captureSessionFailedWithError?(s, error: e)
							}
						}
						
						s.movieOutputURL = s.uniqueURL()
						if let v: URL = s.movieOutputURL {
							s.movieOutput.startRecording(toOutputFileURL: v, recordingDelegate: s)
						}
					}
				}
			}
		}
	}
	
	/**
	:name:	stopRecording
	*/
	open func stopRecording() {
		if isRecording {
			movieOutput.stopRecording()
		}
	}
	
	/**
	:name:	captureOutput
	*/
	open func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
		isRecording = true
		delegate?.captureDidStartRecordingToOutputFileAtURL?(self, captureOutput: captureOutput, fileURL: fileURL, fromConnections: connections as [AnyObject])
	}
	
	/**
	:name:	captureOutput
	*/
	open func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
		isRecording = false
		delegate?.captureDidFinishRecordingToOutputFileAtURL?(self, captureOutput: captureOutput, outputFileURL: outputFileURL, fromConnections: connections as [AnyObject], error: error as NSError!)
	}
	
	/**
	:name:	prepareSession
	*/
	fileprivate func prepareSession() {
		prepareVideoInput()
		prepareAudioInput()
		prepareImageOutput()
		prepareMovieOutput()
	}
	
	/**
	:name:	prepareVideoInput
	*/
	fileprivate func prepareVideoInput() {
		do {
			activeVideoInput = try AVCaptureDeviceInput(device: AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo))
			if session.canAddInput(activeVideoInput) {
				session.addInput(activeVideoInput)
			}
		} catch let e as NSError {
			delegate?.captureSessionFailedWithError?(self, error: e)
		}
	}
	
	/**
	:name:	prepareAudioInput
	*/
	fileprivate func prepareAudioInput() {
		do {
			activeAudioInput = try AVCaptureDeviceInput(device: AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio))
			if session.canAddInput(activeAudioInput) {
				session.addInput(activeAudioInput)
			}
		} catch let e as NSError {
			delegate?.captureSessionFailedWithError?(self, error: e)
		}
	}
	
	/**
	:name:	prepareImageOutput
	*/
	fileprivate func prepareImageOutput() {
		if session.canAddOutput(imageOutput) {
			imageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
			session.addOutput(imageOutput)
		}
	}
	
	/**
	:name:	prepareMovieOutput
	*/
	fileprivate func prepareMovieOutput() {
		if session.canAddOutput(movieOutput) {
			session.addOutput(movieOutput)
		}
	}
	
	/**
	:name:	cameraWithPosition
	*/
	fileprivate func cameraWithPosition(_ position: AVCaptureDevicePosition) -> AVCaptureDevice? {
		let devices: Array<AVCaptureDevice> = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) as! Array<AVCaptureDevice>
		for device in devices {
			if device.position == position {
				return device
			}
		}
		return nil
	}
	
	/**
	:name:	uniqueURL
	*/
	fileprivate func uniqueURL() -> URL? {
		do {
			let directory: URL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
			let dateFormatter = DateFormatter()
			dateFormatter.dateStyle = .full
			dateFormatter.timeStyle = .full
			return directory.appendingPathComponent(dateFormatter.string(from: Date()) + ".mov")
		} catch let e as NSError {
			delegate?.captureCreateMovieFileFailedWithError?(self, error: e)
		}
		return nil
	}
	
	/**
	Adjusts the orientation of the image from the capture orientation.
	This is an issue when taking images, the capture orientation is not set correctly
	when using Portrait.
	- Parameter image: A UIImage to adjust.
	- Returns: An optional UIImage if successful.
	*/
	fileprivate func adjustOrientationForImage(_ image: UIImage) -> UIImage? {
		guard .up != image.imageOrientation else {
			return image
		}
		
		var transform: CGAffineTransform = CGAffineTransform.identity
		
		// Rotate if Left, Right, or Down.
		switch image.imageOrientation {
		case .down, .downMirrored:
			transform = transform.translatedBy(x: image.size.width, y: image.size.height)
			transform = transform.rotated(by: CGFloat(M_PI))
		case .left, .leftMirrored:
			transform = transform.translatedBy(x: image.size.width, y: 0)
			transform = transform.rotated(by: CGFloat(M_PI_2))
		case .right, .rightMirrored:
			transform = transform.translatedBy(x: 0, y: image.size.height)
			transform = transform.rotated(by: -CGFloat(M_PI_2))
		default:break
		}
		
		// Flip if mirrored.
		switch image.imageOrientation {
		case .upMirrored, .downMirrored:
			transform = transform.translatedBy(x: image.size.width, y: 0)
			transform = transform.scaledBy(x: -1, y: 1)
		case .leftMirrored, .rightMirrored:
			transform = transform.translatedBy(x: image.size.height, y: 0)
			transform = transform.scaledBy(x: -1, y: 1)
		default:break
		}
		
		// Draw the underlying CGImage with the calculated transform.
		guard let context = CGContext(data: nil, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: (image.cgImage?.bitsPerComponent)!, bytesPerRow: 0, space: (image.cgImage?.colorSpace!)!, bitmapInfo: (image.cgImage?.bitmapInfo.rawValue)!) else {
			return nil
		}
		
		context.concatenate(transform)
		
		switch image.imageOrientation {
		case .left, .leftMirrored, .right, .rightMirrored:
			context.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: image.size.height, height: image.size.width))
		default:
			context.draw(image.cgImage!, in: CGRect(origin: .zero, size: image.size))
		}
		
		guard let CGImage = context.makeImage() else {
			return nil
		}
		
		return UIImage(cgImage: CGImage)
	}
}
