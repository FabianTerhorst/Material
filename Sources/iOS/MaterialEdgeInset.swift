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

public enum MaterialEdgeInset {
	case none
	
	// square
	case square1
	case square2
	case square3
	case square4
	case square5
	case square6
	case square7
	case square8
	case square9
	
	// rectangle
	case wideRectangle1
	case wideRectangle2
	case wideRectangle3
	case wideRectangle4
	case wideRectangle5
	case wideRectangle6
	case wideRectangle7
	case wideRectangle8
	case wideRectangle9
	
	// flipped rectangle
	case tallRectangle1
	case tallRectangle2
	case tallRectangle3
	case tallRectangle4
	case tallRectangle5
	case tallRectangle6
	case tallRectangle7
	case tallRectangle8
	case tallRectangle9
}

/// Converts the MaterialEdgeInset to a UIEdgeInsets value.
public func MaterialEdgeInsetToValue(_ inset: MaterialEdgeInset) -> UIEdgeInsets {
	switch inset {
	case .none:
		return UIEdgeInsets.zero
	
	// square
	case .square1:
		return UIEdgeInsetsMake(4, 4, 4, 4)
	case .square2:
		return UIEdgeInsetsMake(8, 8, 8, 8)
	case .square3:
		return UIEdgeInsetsMake(16, 16, 16, 16)
	case .square4:
		return UIEdgeInsetsMake(24, 24, 24, 24)
	case .square5:
		return UIEdgeInsetsMake(32, 32, 32, 32)
	case .square6:
		return UIEdgeInsetsMake(40, 40, 40, 40)
	case .square7:
		return UIEdgeInsetsMake(48, 48, 48, 48)
	case .square8:
		return UIEdgeInsetsMake(56, 56, 56, 56)
	case .square9:
		return UIEdgeInsetsMake(64, 64, 64, 64)
	
	// rectangle
	case .wideRectangle1:
		return UIEdgeInsetsMake(2, 4, 2, 4)
	case .wideRectangle2:
		return UIEdgeInsetsMake(4, 8, 4, 8)
	case .wideRectangle3:
		return UIEdgeInsetsMake(8, 16, 8, 16)
	case .wideRectangle4:
		return UIEdgeInsetsMake(12, 24, 12, 24)
	case .wideRectangle5:
		return UIEdgeInsetsMake(16, 32, 16, 32)
	case .wideRectangle6:
		return UIEdgeInsetsMake(20, 40, 20, 40)
	case .wideRectangle7:
		return UIEdgeInsetsMake(24, 48, 24, 48)
	case .wideRectangle8:
		return UIEdgeInsetsMake(28, 56, 28, 56)
	case .wideRectangle9:
		return UIEdgeInsetsMake(32, 64, 32, 64)
		
	// flipped rectangle
	case .tallRectangle1:
		return UIEdgeInsetsMake(4, 2, 4, 2)
	case .tallRectangle2:
		return UIEdgeInsetsMake(8, 4, 8, 4)
	case .tallRectangle3:
		return UIEdgeInsetsMake(16, 8, 16, 8)
	case .tallRectangle4:
		return UIEdgeInsetsMake(24, 12, 24, 12)
	case .tallRectangle5:
		return UIEdgeInsetsMake(32, 16, 32, 16)
	case .tallRectangle6:
		return UIEdgeInsetsMake(40, 20, 40, 20)
	case .tallRectangle7:
		return UIEdgeInsetsMake(48, 24, 48, 24)
	case .tallRectangle8:
		return UIEdgeInsetsMake(56, 28, 56, 28)
	case .tallRectangle9:
		return UIEdgeInsetsMake(64, 32, 64, 32)
	}
}
