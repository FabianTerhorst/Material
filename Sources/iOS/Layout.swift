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

open class Layout {
	/// Parent UIView context.
	internal weak var parent: UIView?
    
    /// Child UIView context.
    internal weak var child: UIView?
	
	/**
	An initializer that takes in a parent context.
	- Parameter parent: An optional parent UIView.
	*/
	public init(parent: UIView?) {
		self.parent = parent
	}

	/**
	An initializer that takes in a parent context and child context.
	- Parameter parent: An optional parent UIView.
	- Parameter child: An optional child UIView.
	*/
	public init(parent: UIView?, child: UIView?) {
        self.parent = parent
        self.child = child
    }
	
	/**
	Prints a debug message when the parent context is not available.
	- Parameter function: A String representation of the function that
	caused the issue.
	- Returns: The current Layout instance.
	*/
	internal func debugParentNotAvailableMessage(_ function: String = #function) -> Layout {
		debugPrint("[Material Layout Error: Parent view context is not available for \(function).")
		return self
	}
	
	/**
	Prints a debug message when the child context is not available.
	- Parameter function: A String representation of the function that
	caused the issue.
	- Returns: The current Layout instance.
	*/
	internal func debugChildNotAvailableMessage(_ function: String = #function) -> Layout {
		debugPrint("[Material Layout Error: Chld view context is not available for \(function).")
		return self
	}

	/**
	Sets the width of a view.
	- Parameter child: A child UIView to layout.
	- Parameter width: A CGFloat value.
	- Returns: The current Layout instance.
	*/
	open func width(_ child: UIView, width: CGFloat) -> Layout {
		guard let v: UIView = parent else {
			return debugParentNotAvailableMessage()
        }
		self.child = child
		Layout.width(v, child: child, width: width)
        return self
	}
    
	/**
	Sets the width of a view assuming a child context view.
	- Parameter width: A CGFloat value.
	- Returns: The current Layout instance.
	*/
    open func width(_ width: CGFloat) -> Layout {
		guard let v: UIView = child else {
			return debugChildNotAvailableMessage()
		}
		return self.width(v, width: width)
    }
	
	/**
	Sets the height of a view.
	- Parameter child: A child UIView to layout.
	- Parameter height: A CGFloat value.
	- Returns: The current Layout instance.
	*/
	open func height(_ child: UIView, height: CGFloat) -> Layout {
		guard let v: UIView = parent else {
			return debugParentNotAvailableMessage()
        }
		self.child = child
        Layout.height(v, child: child, height: height)
		return self
	}
	
	/**
	Sets the height of a view assuming a child context view.
	- Parameter height: A CGFloat value.
	- Returns: The current Layout instance.
	*/
    open func height(_ height: CGFloat) -> Layout {
        guard let v: UIView = child else {
			return debugChildNotAvailableMessage()
        }
		return self.height(v, height: height)
    }
    
	/**
	Sets the width and height of a view.
	- Parameter child: A child UIView to layout.
	- Parameter width: A CGFloat value.
	- Parameter height: A CGFloat value.
	- Returns: The current Layout instance.
	*/
	open func size(_ child: UIView, width: CGFloat, height: CGFloat) -> Layout {
		guard let v: UIView = parent else {
			return debugParentNotAvailableMessage()
        }
		self.child = child
        Layout.size(v, child: child, width: width, height: height)
        return self
	}
    
	/**
	Sets the width and height of a view assuming a child context view.
	- Parameter width: A CGFloat value.
	- Parameter height: A CGFloat value.
	- Returns: The current Layout instance.
	*/
	open func size(width: CGFloat, height: CGFloat) -> Layout {
        guard let v: UIView = child else {
			return debugChildNotAvailableMessage()
        }
        return size(v, width: width, height: height)
    }
	
	/**
	A collection of children views are horizontally stretched with optional left, 
	right padding and interim spacing.
	- Parameter children: An Array UIView to layout.
	- Parameter left: A CGFloat value for padding the left side.
	- Parameter right: A CGFloat value for padding the right side.
	- Parameter spacing: A CGFloat value for interim spacing.
	- Returns: The current Layout instance.
	*/
	open func horizontally(_ children: Array<UIView>, left: CGFloat = 0, right: CGFloat = 0, spacing: CGFloat = 0) -> Layout {
		guard let v: UIView = parent else {
			return debugParentNotAvailableMessage()
        }
        Layout.horizontally(v, children: children, left: left, right: right, spacing: spacing)
        return self
	}
	
	/**
	A collection of children views are vertically stretched with optional top,
	bottom padding and interim spacing.
	- Parameter children: An Array UIView to layout.
	- Parameter top: A CGFloat value for padding the top side.
	- Parameter bottom: A CGFloat value for padding the bottom side.
	- Parameter spacing: A CGFloat value for interim spacing.
	- Returns: The current Layout instance.
	*/
	open func vertically(_ children: Array<UIView>, top: CGFloat = 0, bottom: CGFloat = 0, spacing: CGFloat = 0) -> Layout {
		guard let v: UIView = parent else {
			return debugParentNotAvailableMessage()
        }
        Layout.vertically(v, children: children, top: top, bottom: bottom, spacing: spacing)
        return self
	}
	
	/**
	A child view is horizontally stretched with optional left and right padding.
	- Parameter child: A child UIView to layout.
	- Parameter left: A CGFloat value for padding the left side.
	- Parameter right: A CGFloat value for padding the right side.
	- Returns: The current Layout instance.
	*/
	open func horizontally(_ child: UIView, left: CGFloat = 0, right: CGFloat = 0) -> Layout {
		guard let v: UIView = parent else {
			return debugParentNotAvailableMessage()
        }
		self.child = child
        Layout.horizontally(v, child: child, left: left, right: right)
        return self
	}
    
	/**
	A child view is horizontally stretched with optional left and right padding.
	- Parameter left: A CGFloat value for padding the left side.
	- Parameter right: A CGFloat value for padding the right side.
	- Returns: The current Layout instance.
	*/
    open func horizontally(left: CGFloat = 0, right: CGFloat = 0) -> Layout {
        guard let v: UIView = child else {
            return debugChildNotAvailableMessage()
        }
        return horizontally(v, left: left, right: right)
    }
	
	/**
	A child view is vertically stretched with optional left and right padding.
	- Parameter child: A child UIView to layout.
	- Parameter top: A CGFloat value for padding the top side.
	- Parameter bottom: A CGFloat value for padding the bottom side.
	- Returns: The current Layout instance.
	*/
	open func vertically(_ child: UIView, top: CGFloat = 0, bottom: CGFloat = 0) -> Layout {
		guard let v: UIView = parent else {
			return debugParentNotAvailableMessage()
        }
		self.child = child
        Layout.vertically(v, child: child, top: top, bottom: bottom)
        return self
	}
    
	/**
	A child view is vertically stretched with optional left and right padding.
	- Parameter top: A CGFloat value for padding the top side.
	- Parameter bottom: A CGFloat value for padding the bottom side.
	- Returns: The current Layout instance.
	*/
	open func vertically(top: CGFloat = 0, bottom: CGFloat = 0) -> Layout {
        guard let v: UIView = child else {
            return debugChildNotAvailableMessage()
        }
        return vertically(v, top: top, bottom: bottom)
    }
	
	/**
	A child view is vertically and horizontally stretched with optional top, left, bottom and right padding.
	- Parameter child: A child UIView to layout.
	- Parameter top: A CGFloat value for padding the top side.
	- Parameter left: A CGFloat value for padding the left side.
	- Parameter bottom: A CGFloat value for padding the bottom side.
	- Parameter right: A CGFloat value for padding the right side.
	- Returns: The current Layout instance.
	*/
	open func edges(_ child: UIView, top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> Layout {
		guard let v: UIView = parent else {
			return debugParentNotAvailableMessage()
		}
		self.child = child
		Layout.edges(v, child: child, top: top, left: left, bottom: bottom, right: right)
		return self
	}
	
	/**
	A child view is vertically and horizontally stretched with optional top, left, bottom and right padding.
	- Parameter child: A child UIView to layout.
	- Parameter top: A CGFloat value for padding the top side.
	- Parameter left: A CGFloat value for padding the left side.
	- Parameter bottom: A CGFloat value for padding the bottom side.
	- Parameter right: A CGFloat value for padding the right side.
	- Returns: The current Layout instance.
	*/
	open func edges(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> Layout {
		guard let v: UIView = child else {
			return debugChildNotAvailableMessage()
		}
		return edges(v, top: top, left: left, bottom: bottom, right: right)
	}
	
	/**
	A child view is aligned from the top with optional top padding.
	- Parameter child: A child UIView to layout.
	- Parameter top: A CGFloat value for padding the top side.
	- Returns: The current Layout instance.
	*/
	open func top(_ child: UIView, top: CGFloat = 0) -> Layout {
		guard let v: UIView = parent else {
			return debugParentNotAvailableMessage()
		}
		self.child = child
		Layout.top(v, child: child, top: top)
		return self
	}
	
	/**
	A child view is aligned from the top with optional top padding.
	- Parameter top: A CGFloat value for padding the top side.
	- Returns: The current Layout instance.
	*/
	open func top(_ top: CGFloat = 0) -> Layout {
		guard let v: UIView = child else {
			return debugChildNotAvailableMessage()
		}
		return self.top(v, top: top)
	}
	
	/**
	A child view is aligned from the left with optional left padding.
	- Parameter child: A child UIView to layout.
	- Parameter left: A CGFloat value for padding the left side.
	- Returns: The current Layout instance.
	*/
	open func left(_ child: UIView, left: CGFloat = 0) -> Layout {
		guard let v: UIView = parent else {
			return debugParentNotAvailableMessage()
		}
		self.child = child
		Layout.left(v, child: child, left: left)
		return self
	}
	
	/**
	A child view is aligned from the left with optional left padding.
	- Parameter left: A CGFloat value for padding the left side.
	- Returns: The current Layout instance.
	*/
	open func left(_ left: CGFloat = 0) -> Layout {
		guard let v: UIView = child else {
			return debugChildNotAvailableMessage()
		}
		return self.left(v, left: left)
	}
	
	/**
	A child view is aligned from the bottom with optional bottom padding.
	- Parameter child: A child UIView to layout.
	- Parameter bottom: A CGFloat value for padding the bottom side.
	- Returns: The current Layout instance.
	*/
	open func bottom(_ child: UIView, bottom: CGFloat = 0) -> Layout {
		guard let v: UIView = parent else {
			return debugParentNotAvailableMessage()
		}
		self.child = child
		Layout.bottom(v, child: child, bottom: bottom)
		return self
	}
	
	/**
	A child view is aligned from the bottom with optional bottom padding.
	- Parameter bottom: A CGFloat value for padding the bottom side.
	- Returns: The current Layout instance.
	*/
	open func bottom(_ bottom: CGFloat = 0) -> Layout {
		guard let v: UIView = child else {
			return debugChildNotAvailableMessage()
		}
		return self.bottom(v, bottom: bottom)
	}
	
	
	/**
	A child view is aligned from the right with optional right padding.
	- Parameter child: A child UIView to layout.
	- Parameter right: A CGFloat value for padding the right side.
	- Returns: The current Layout instance.
	*/
	open func right(_ child: UIView, right: CGFloat = 0) -> Layout {
		guard let v: UIView = parent else {
			return debugParentNotAvailableMessage()
		}
		self.child = child
		Layout.right(v, child: child, right: right)
		return self
	}
	
	/**
	A child view is aligned from the right with optional right padding.
	- Parameter right: A CGFloat value for padding the right side.
	- Returns: The current Layout instance.
	*/
	open func right(_ right: CGFloat = 0) -> Layout {
		guard let v: UIView = child else {
			return debugChildNotAvailableMessage()
		}
		return self.right(v, right: right)
	}
	
	/**
	A child view is aligned from the top left with optional top and left padding.
	- Parameter child: A child UIView to layout.
	- Parameter top: A CGFloat value for padding the top side.
	- Parameter left: A CGFloat value for padding the left side.
	- Returns: The current Layout instance.
	*/
	open func topLeft(_ child: UIView, top: CGFloat = 0, left: CGFloat = 0) -> Layout {
		guard let v: UIView = parent else {
			return debugParentNotAvailableMessage()
		}
		self.child = child
		Layout.topLeft(v, child: child, top: top, left: left)
		return self
	}
	
	/**
	A child view is aligned from the top left with optional top and left padding.
	- Parameter top: A CGFloat value for padding the top side.
	- Parameter left: A CGFloat value for padding the left side.
	- Returns: The current Layout instance.
	*/
	open func topLeft(top: CGFloat = 0, left: CGFloat = 0) -> Layout {
		guard let v: UIView = child else {
			return debugChildNotAvailableMessage()
		}
		return topLeft(v, top: top, left: left)
	}
	
	/**
	A child view is aligned from the top right with optional top and right padding.
	- Parameter child: A child UIView to layout.
	- Parameter top: A CGFloat value for padding the top side.
	- Parameter right: A CGFloat value for padding the right side.
	- Returns: The current Layout instance.
	*/
	open func topRight(_ child: UIView, top: CGFloat = 0, right: CGFloat = 0) -> Layout {
		guard let v: UIView = parent else {
			return debugParentNotAvailableMessage()
		}
		self.child = child
		Layout.topRight(v, child: child, top: top, right: right)
		return self
	}
	
	/**
	A child view is aligned from the top right with optional top and right padding.
	- Parameter top: A CGFloat value for padding the top side.
	- Parameter right: A CGFloat value for padding the right side.
	- Returns: The current Layout instance.
	*/
	open func topRight(top: CGFloat = 0, right: CGFloat = 0) -> Layout {
		guard let v: UIView = child else {
			return debugChildNotAvailableMessage()
		}
		return topRight(v, top: top, right: right)
	}
	
	/**
	A child view is aligned from the bottom left with optional bottom and left padding.
	- Parameter child: A child UIView to layout.
	- Parameter bottom: A CGFloat value for padding the bottom side.
	- Parameter left: A CGFloat value for padding the left side.
	- Returns: The current Layout instance.
	*/
	open func bottomLeft(_ child: UIView, bottom: CGFloat = 0, left: CGFloat = 0) -> Layout {
		guard let v: UIView = parent else {
			return debugParentNotAvailableMessage()
		}
		self.child = child
		Layout.bottomLeft(v, child: child, bottom: bottom, left: left)
		return self
	}
	
	/**
	A child view is aligned from the bottom left with optional bottom and left padding.
	- Parameter bottom: A CGFloat value for padding the bottom side.
	- Parameter left: A CGFloat value for padding the left side.
	- Returns: The current Layout instance.
	*/
	open func bottomLeft(bottom: CGFloat = 0, left: CGFloat = 0) -> Layout {
		guard let v: UIView = child else {
			return debugChildNotAvailableMessage()
		}
		return bottomLeft(v, bottom: bottom, left: left)
	}
	
	/**
	A child view is aligned from the bottom right with optional bottom and right padding.
	- Parameter child: A child UIView to layout.
	- Parameter bottom: A CGFloat value for padding the bottom side.
	- Parameter right: A CGFloat value for padding the right side.
	- Returns: The current Layout instance.
	*/
	open func bottomRight(_ child: UIView, bottom: CGFloat = 0, right: CGFloat = 0) -> Layout {
		guard let v: UIView = parent else {
			return debugParentNotAvailableMessage()
		}
		self.child = child
		Layout.bottomRight(v, child: child, bottom: bottom, right: right)
		return self
	}
	
	/**
	A child view is aligned from the bottom right with optional bottom and right padding.
	- Parameter bottom: A CGFloat value for padding the bottom side.
	- Parameter right: A CGFloat value for padding the right side.
	- Returns: The current Layout instance.
	*/
	open func bottomRight(bottom: CGFloat = 0, right: CGFloat = 0) -> Layout {
		guard let v: UIView = child else {
			return debugChildNotAvailableMessage()
		}
		return bottomRight(v, bottom: bottom, right: right)
	}
	
	/**
	A child view is aligned at the center with an optional offsetX and offsetY value.
	- Parameter child: A child UIView to layout.
	- Parameter offsetX: A CGFloat value for the offset along the x axis.
	- Parameter offsetX: A CGFloat value for the offset along the y axis.
	- Returns: The current Layout instance.
	*/
	open func center(_ child: UIView, offsetX: CGFloat = 0, offsetY: CGFloat = 0) -> Layout {
		guard let v: UIView = parent else {
			return debugParentNotAvailableMessage()
        }
		self.child = child
		Layout.center(v, child: child, offsetX: offsetX, offsetY: offsetY)
        return self
	}
	
	/**
	A child view is aligned at the center with an optional offsetX and offsetY value.
	- Parameter offsetX: A CGFloat value for the offset along the x axis.
	- Parameter offsetX: A CGFloat value for the offset along the y axis.
	- Returns: The current Layout instance.
	*/
	open func center(offsetX: CGFloat = 0, offsetY: CGFloat = 0) -> Layout {
        guard let v: UIView = child else {
            return debugChildNotAvailableMessage()
        }
		return center(v, offsetX: offsetX, offsetY: offsetY)
    }
	
	/**
	A child view is aligned at the center horizontally with an optional offset value.
	- Parameter child: A child UIView to layout.
	- Parameter offset: A CGFloat value for the offset along the x axis.
	- Returns: The current Layout instance.
	*/
	open func centerHorizontally(_ child: UIView, offset: CGFloat = 0) -> Layout {
		guard let v: UIView = parent else {
			return debugParentNotAvailableMessage()
        }
		self.child = child
        Layout.centerHorizontally(v, child: child, offset: offset)
        return self
	}
    
	/**
	A child view is aligned at the center horizontally with an optional offset value.
	- Parameter offset: A CGFloat value for the offset along the x axis.
	- Returns: The current Layout instance.
	*/
	open func centerHorizontally(_ offset: CGFloat = 0) -> Layout {
        guard let v: UIView = child else {
            return debugChildNotAvailableMessage()
        }
        return centerHorizontally(v, offset: offset)
    }
	
	/**
	A child view is aligned at the center vertically with an optional offset value.
	- Parameter child: A child UIView to layout.
	- Parameter offset: A CGFloat value for the offset along the y axis.
	- Returns: The current Layout instance.
	*/
	open func centerVertically(_ child: UIView, offset: CGFloat = 0) -> Layout {
		guard let v: UIView = parent else {
			return debugParentNotAvailableMessage()
        }
		self.child = child
        Layout.centerVertically(v, child: child, offset: offset)
        return self
	}
    
	/**
	A child view is aligned at the center vertically with an optional offset value.
	- Parameter offset: A CGFloat value for the offset along the y axis.
	- Returns: The current Layout instance.
	*/
	open func centerVertically(_ offset: CGFloat = 0) -> Layout {
        guard let v: UIView = child else {
            return debugChildNotAvailableMessage()
        }
        return centerVertically(v, offset: offset)
    }
}

/// Layout
public extension Layout {
	/**
	Sets the width of a view.
	- Parameter parent: A parent UIView context.
	- Parameter child: A child UIView to layout.
	- Parameter width: A CGFloat value.
	*/
	public class func width(_ parent: UIView, child: UIView, width: CGFloat = 0) {
		prepareForConstraint(parent, child: child)
		parent.addConstraint(NSLayoutConstraint(item: child, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: width))
	}
	
	/**
	Sets the height of a view.
	- Parameter parent: A parent UIView context.
	- Parameter child: A child UIView to layout.
	- Parameter height: A CGFloat value.
	*/
	public class func height(_ parent: UIView, child: UIView, height: CGFloat = 0) {
		prepareForConstraint(parent, child: child)
		parent.addConstraint(NSLayoutConstraint(item: child, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: height))
	}
	
	/**
	Sets the width and height of a view.
	- Parameter parent: A parent UIView context.
	- Parameter child: A child UIView to layout.
	- Parameter width: A CGFloat value.
	- Parameter height: A CGFloat value.
	*/
	public class func size(_ parent: UIView, child: UIView, width: CGFloat = 0, height: CGFloat = 0) {
		Layout.width(parent, child: child, width: width)
		Layout.height(parent, child: child, height: height)
	}
	
	/**
	A collection of children views are horizontally stretched with optional left,
	right padding and interim spacing.
	- Parameter parent: A parent UIView context.
	- Parameter children: An Array UIView to layout.
	- Parameter left: A CGFloat value for padding the left side.
	- Parameter right: A CGFloat value for padding the right side.
	- Parameter spacing: A CGFloat value for interim spacing.
	*/
	public class func horizontally(_ parent: UIView, children: Array<UIView>, left: CGFloat = 0, right: CGFloat = 0, spacing: CGFloat = 0) {
		prepareForConstraint(parent, children: children)
		if 0 < children.count {
			parent.addConstraint(NSLayoutConstraint(item: children[0], attribute: .left, relatedBy: .equal, toItem: parent, attribute: .left, multiplier: 1, constant: left))
			for i in 1..<children.count {
				parent.addConstraint(NSLayoutConstraint(item: children[i], attribute: .left, relatedBy: .equal, toItem: children[i - 1], attribute: .right, multiplier: 1, constant: spacing))
				parent.addConstraint(NSLayoutConstraint(item: children[i], attribute: .width, relatedBy: .equal, toItem: children[0], attribute: .width, multiplier: 1, constant: 0))
			}
			parent.addConstraint(NSLayoutConstraint(item: children[children.count - 1], attribute: .right, relatedBy: .equal, toItem: parent, attribute: .right, multiplier: 1, constant: -right))
		}
	}
	
	/**
	A collection of children views are vertically stretched with optional top,
	bottom padding and interim spacing.
	- Parameter parent: A parent UIView context.
	- Parameter children: An Array UIView to layout.
	- Parameter top: A CGFloat value for padding the top side.
	- Parameter bottom: A CGFloat value for padding the bottom side.
	- Parameter spacing: A CGFloat value for interim spacing.
	*/
	public class func vertically(_ parent: UIView, children: Array<UIView>, top: CGFloat = 0, bottom: CGFloat = 0, spacing: CGFloat = 0) {
		prepareForConstraint(parent, children: children)
		if 0 < children.count {
			parent.addConstraint(NSLayoutConstraint(item: children[0], attribute: .top, relatedBy: .equal, toItem: parent, attribute: .top, multiplier: 1, constant: top))
			for i in 1..<children.count {
				parent.addConstraint(NSLayoutConstraint(item: children[i], attribute: .top, relatedBy: .equal, toItem: children[i - 1], attribute: .bottom, multiplier: 1, constant: spacing))
				parent.addConstraint(NSLayoutConstraint(item: children[i], attribute: .height, relatedBy: .equal, toItem: children[0], attribute: .height, multiplier: 1, constant: 0))
			}
			parent.addConstraint(NSLayoutConstraint(item: children[children.count - 1], attribute: .bottom, relatedBy: .equal, toItem: parent, attribute: .bottom, multiplier: 1, constant: -bottom))
		}
	}
	
	/**
	A child view is horizontally stretched with optional left and right padding.
	- Parameter parent: A parent UIView context.
	- Parameter child: A child UIView to layout.
	- Parameter left: A CGFloat value for padding the left side.
	- Parameter right: A CGFloat value for padding the right side.
	*/
	public class func horizontally(_ parent: UIView, child: UIView, left: CGFloat = 0, right: CGFloat = 0) {
		prepareForConstraint(parent, child: child)
		parent.addConstraint(NSLayoutConstraint(item: child, attribute: .left, relatedBy: .equal, toItem: parent, attribute: .left, multiplier: 1, constant: left))
		parent.addConstraint(NSLayoutConstraint(item: child, attribute: .right, relatedBy: .equal, toItem: parent, attribute: .right, multiplier: 1, constant: -right))
	}
	
	/**
	A child view is vertically stretched with optional left and right padding.
	- Parameter parent: A parent UIView context.
	- Parameter child: A child UIView to layout.
	- Parameter top: A CGFloat value for padding the top side.
	- Parameter bottom: A CGFloat value for padding the bottom side.
	*/
	public class func vertically(_ parent: UIView, child: UIView, top: CGFloat = 0, bottom: CGFloat = 0) {
		prepareForConstraint(parent, child: child)
		parent.addConstraint(NSLayoutConstraint(item: child, attribute: .top, relatedBy: .equal, toItem: parent, attribute: .top, multiplier: 1, constant: top))
		parent.addConstraint(NSLayoutConstraint(item: child, attribute: .bottom, relatedBy: .equal, toItem: parent, attribute: .bottom, multiplier: 1, constant: -bottom))
	}
	
	/**
	A child view is vertically and horizontally stretched with optional top, left, bottom and right padding.
	- Parameter parent: A parent UIView context.
	- Parameter child: A child UIView to layout.
	- Parameter top: A CGFloat value for padding the top side.
	- Parameter left: A CGFloat value for padding the left side.
	- Parameter bottom: A CGFloat value for padding the bottom side.
	- Parameter right: A CGFloat value for padding the right side.
	*/
	public class func edges(_ parent: UIView, child: UIView, top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) {
		horizontally(parent, child: child, left: left, right: right)
		vertically(parent, child: child, top: top, bottom: bottom)
	}
	
	/**
	A child view is aligned from the top with optional top padding.
	- Parameter parent: A parent UIView context.
	- Parameter child: A child UIView to layout.
	- Parameter top: A CGFloat value for padding the top side.
	- Returns: The current Layout instance.
	*/
	public class func top(_ parent: UIView, child: UIView, top: CGFloat = 0) {
		prepareForConstraint(parent, child: child)
		parent.addConstraint(NSLayoutConstraint(item: child, attribute: .top, relatedBy: .equal, toItem: parent, attribute: .top, multiplier: 1, constant: top))
	}
	
	/**
	A child view is aligned from the left with optional left padding.
	- Parameter parent: A parent UIView context.
	- Parameter child: A child UIView to layout.
	- Parameter left: A CGFloat value for padding the left side.
	- Returns: The current Layout instance.
	*/
	public class func left(_ parent: UIView, child: UIView, left: CGFloat = 0) {
		prepareForConstraint(parent, child: child)
		parent.addConstraint(NSLayoutConstraint(item: child, attribute: .left, relatedBy: .equal, toItem: parent, attribute: .left, multiplier: 1, constant: left))
	}
	
	/**
	A child view is aligned from the bottom with optional bottom padding.
	- Parameter parent: A parent UIView context.
	- Parameter child: A child UIView to layout.
	- Parameter bottom: A CGFloat value for padding the bottom side.
	- Returns: The current Layout instance.
	*/
	public class func bottom(_ parent: UIView, child: UIView, bottom: CGFloat = 0) {
		prepareForConstraint(parent, child: child)
		parent.addConstraint(NSLayoutConstraint(item: child, attribute: .bottom, relatedBy: .equal, toItem: parent, attribute: .bottom, multiplier: 1, constant: -bottom))
	}
	
	/**
	A child view is aligned from the right with optional right padding.
	- Parameter parent: A parent UIView context.
	- Parameter child: A child UIView to layout.
	- Parameter right: A CGFloat value for padding the right side.
	- Returns: The current Layout instance.
	*/
	public class func right(_ parent: UIView, child: UIView, right: CGFloat = 0) {
		prepareForConstraint(parent, child: child)
		parent.addConstraint(NSLayoutConstraint(item: child, attribute: .right, relatedBy: .equal, toItem: parent, attribute: .right, multiplier: 1, constant: -right))
	}
	
	/**
	A child view is aligned from the top left with optional top and left padding.
	- Parameter parent: A parent UIView context.
	- Parameter child: A child UIView to layout.
	- Parameter top: A CGFloat value for padding the top side.
	- Parameter left: A CGFloat value for padding the left side.
	- Returns: The current Layout instance.
	*/
	public class func topLeft(_ parent: UIView, child: UIView, top t: CGFloat = 0, left l: CGFloat = 0) {
		top(parent, child: child, top: t)
		left(parent, child: child, left: l)
	}
	
	/**
	A child view is aligned from the top right with optional top and right padding.
	- Parameter parent: A parent UIView context.
	- Parameter child: A child UIView to layout.
	- Parameter top: A CGFloat value for padding the top side.
	- Parameter right: A CGFloat value for padding the right side.
	- Returns: The current Layout instance.
	*/
	public class func topRight(_ parent: UIView, child: UIView, top t: CGFloat = 0, right r: CGFloat = 0) {
		top(parent, child: child, top: t)
		right(parent, child: child, right: r)
	}
	
	/**
	A child view is aligned from the bottom left with optional bottom and left padding.
	- Parameter parent: A parent UIView context.
	- Parameter child: A child UIView to layout.
	- Parameter bottom: A CGFloat value for padding the bottom side.
	- Parameter left: A CGFloat value for padding the left side.
	- Returns: The current Layout instance.
	*/
	public class func bottomLeft(_ parent: UIView, child: UIView, bottom b: CGFloat = 0, left l: CGFloat = 0) {
		bottom(parent, child: child, bottom: b)
		left(parent, child: child, left: l)
	}
	
	/**
	A child view is aligned from the bottom right with optional bottom and right padding.
	- Parameter parent: A parent UIView context.
	- Parameter child: A child UIView to layout.
	- Parameter bottom: A CGFloat value for padding the bottom side.
	- Parameter right: A CGFloat value for padding the right side.
	- Returns: The current Layout instance.
	*/
	public class func bottomRight(_ parent: UIView, child: UIView, bottom b: CGFloat = 0, right r: CGFloat = 0) {
		bottom(parent, child: child, bottom: b)
		right(parent, child: child, right: r)
	}
	
	/**
	A child view is aligned at the center with an optional offsetX and offsetY value.
	- Parameter parent: A parent UIView context.
	- Parameter child: A child UIView to layout.
	- Parameter offsetX: A CGFloat value for the offset along the x axis.
	- Parameter offsetX: A CGFloat value for the offset along the y axis.
	- Returns: The current Layout instance.
	*/
	public class func center(_ parent: UIView, child: UIView, offsetX: CGFloat = 0, offsetY: CGFloat = 0) {
		centerHorizontally(parent, child: child, offset: offsetX)
		centerVertically(parent, child: child, offset: offsetY)
	}
	
	/**
	A child view is aligned at the center horizontally with an optional offset value.
	- Parameter parent: A parent UIView context.
	- Parameter child: A child UIView to layout.
	- Parameter offset: A CGFloat value for the offset along the y axis.
	- Returns: The current Layout instance.
	*/
	public class func centerHorizontally(_ parent: UIView, child: UIView, offset: CGFloat = 0) {
		prepareForConstraint(parent, child: child)
		parent.addConstraint(NSLayoutConstraint(item: child, attribute: .centerX, relatedBy: .equal, toItem: parent, attribute: .centerX, multiplier: 1, constant: offset))
	}
	
	/**
	A child view is aligned at the center vertically with an optional offset value.
	- Parameter parent: A parent UIView context.
	- Parameter child: A child UIView to layout.
	- Parameter offset: A CGFloat value for the offset along the y axis.
	- Returns: The current Layout instance.
	*/
	public class func centerVertically(_ parent: UIView, child: UIView, offset: CGFloat = 0) {
		prepareForConstraint(parent, child: child)
		parent.addConstraint(NSLayoutConstraint(item: child, attribute: .centerY, relatedBy: .equal, toItem: parent, attribute: .centerY, multiplier: 1, constant: offset))
	}
	
	/**
	Creats an Array with a NSLayoutConstraint value.
	- Parameter format: The VFL format string.
	- Parameter options: Additional NSLayoutFormatOptions.
	- Parameter metrics: An optional Dictionary<String, AnyObject> of metric key / value pairs.
	- Parameter views: A Dictionary<String, AnyObject> of view key / value pairs.
	- Returns: The Array<NSLayoutConstraint> instance.
	*/
	public class func constraint(_ format: String, options: NSLayoutFormatOptions, metrics: Dictionary<String, AnyObject>?, views: Dictionary<String, AnyObject>) -> Array<NSLayoutConstraint> {
		for (_, a) in views {
			if let v: UIView = a as? UIView {
				v.translatesAutoresizingMaskIntoConstraints = false
			}
		}
		return NSLayoutConstraint.constraints(
			withVisualFormat: format,
			options: options,
			metrics: metrics,
			views: views
		)
	}
	
	/**
	Prepares the relationship between the parent view context and child view 
	to layout. If the child is not already added to the view hierarchy as the
	parent's child, then it is added.
	- Parameter parent: A parent UIView context.
	- Parameter child: A child UIView to layout.
	*/
	fileprivate class func prepareForConstraint(_ parent: UIView, child: UIView) {
		if parent != child.superview {
			child.removeFromSuperview()
			parent.addSubview(child)
		}
		child.translatesAutoresizingMaskIntoConstraints = false
	}
	
	/**
	Prepares the relationship between the parent view context and an Array of
	child UIViews.
	- Parameter parent: A parent UIView context.
	- Parameter children: An Array of UIViews.
	*/
	fileprivate class func prepareForConstraint(_ parent: UIView, children: [UIView]) {
		for v in children {
			prepareForConstraint(parent, child: v)
		}
	}
}

/// A memory reference to the LayoutKey instance for UIView extensions.
private var LayoutKey: UInt8 = 0

/// Layout extension for UIView.
public extension UIView {
	/// Layout reference.
	public fileprivate(set) var layout: Layout {
		get {
			return MaterialAssociatedObject(self, key: &LayoutKey) {
				return Layout(parent: self)
			}
		}
		set(value) {
			MaterialAssociateObject(self, key: &LayoutKey, value: value)
		}
	}
    
	/**
	Used to chain layout constraints on a child context.
	- Parameter child: A child UIView to layout.
	- Returns: The current Layout instance.
	*/
    public func layout(_ child: UIView) -> Layout {
        return Layout(parent: self, child: child)
    }
}
