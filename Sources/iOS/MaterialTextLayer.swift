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
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


open class MaterialTextLayer : CATextLayer {
	/**
	:name:	fontType
	*/
	open var fontType: UIFont? {
		didSet {
			if let v: UIFont = fontType {
				super.font = CGFont(v.fontName as CFString)!
				pointSize = v.pointSize
			}
		}
	}
	
	/**
	:name:	text
	*/
	@IBInspectable open var text: String? {
		didSet {
			string = text as? AnyObject
		}
	}
	
	/**
	:name:	pointSize
	*/
	@IBInspectable open var pointSize: CGFloat = 10 {
		didSet {
			fontSize = pointSize
		}
	}
	
	/**
	:name:	textColor
	*/
	@IBInspectable open var textColor: UIColor? {
		didSet {
			foregroundColor = textColor?.cgColor
		}
	}
	
	/**
	:name:	textAlignment
	*/
	open var textAlignment: NSTextAlignment = .left {
		didSet {
			switch textAlignment {
			case .left:
				alignmentMode = kCAAlignmentLeft
			case .center:
				alignmentMode = kCAAlignmentCenter
			case .right:
				alignmentMode = kCAAlignmentRight
			case .justified:
				alignmentMode = kCAAlignmentJustified
			case .natural:
				alignmentMode = kCAAlignmentNatural
			}
		}
	}
	
	/**
	:name:	lineBreakMode
	*/
	open var lineBreakMode: NSLineBreakMode = .byWordWrapping {
		didSet {
			switch lineBreakMode {
			case .byWordWrapping: // Wrap at word boundaries, default
				truncationMode = kCATruncationNone
			case .byCharWrapping: // Wrap at character boundaries
				truncationMode = kCATruncationNone
			case .byClipping: // Simply clip
				truncationMode = kCATruncationNone
			case .byTruncatingHead: // Truncate at head of line: "...wxyz"
				truncationMode = kCATruncationStart
			case .byTruncatingTail: // Truncate at tail of line: "abcd..."
				truncationMode = kCATruncationEnd
			case .byTruncatingMiddle: // Truncate middle of line:  "ab...yz"
				truncationMode = kCATruncationMiddle
			}
		}
	}
	
	/**
	:name:	x
	*/
	@IBInspectable open var x: CGFloat {
		get {
			return frame.origin.x
		}
		set(value) {
			frame.origin.x = value
		}
	}
	
	/**
	:name:	y
	*/
	@IBInspectable open var y: CGFloat {
		get {
			return frame.origin.y
		}
		set(value) {
			frame.origin.y = value
		}
	}
	
	/**
	:name:	width
	*/
	@IBInspectable open var width: CGFloat {
		get {
			return frame.size.width
		}
		set(value) {
			frame.size.width = value
		}
	}
	
	/**
	:name:	height
	*/
	@IBInspectable open var height: CGFloat {
		get {
			return frame.size.height
		}
		set(value) {
			frame.size.height = value
		}
	}
	
	/**
	:name: init
	*/
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		prepareLayer()
	}
	
	/**
	:name: init
	*/
	public override init(layer: Any) {
		super.init()
		prepareLayer()
	}
	
	/**
	:name: init
	*/
	public override init() {
		super.init()
		prepareLayer()
	}
	
	/**
	:name: init
	*/
	public convenience init(frame: CGRect) {
		self.init()
		self.frame = frame
	}
	
	/**
	:name:	stringSize
	*/
	open func stringSize(constrainedToWidth width: Double) -> CGSize {
		if let v: UIFont = fontType {
			if 0 < text?.utf16.count {
				return v.stringSize(text!, constrainedToWidth: width)
			}
		}
		return CGSize.zero
	}
	
	/**
	:name:	prepareLayer
	*/
	internal func prepareLayer() {
		textColor = MaterialColor.black
		textAlignment = .left
		isWrapped = true
		contentsScale = MaterialDevice.scale
		lineBreakMode = .byWordWrapping
	}
}
