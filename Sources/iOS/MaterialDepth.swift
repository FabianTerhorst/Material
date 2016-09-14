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

public typealias MaterialDepthType = (offset: CGSize, opacity: Float, radius: CGFloat)

public enum MaterialDepth {
	case none
	case depth1
	case depth2
	case depth3
	case depth4
	case depth5
}

/// Converts the MaterialDepth enum to a MaterialDepthType value.
public func MaterialDepthToValue(_ depth: MaterialDepth) -> MaterialDepthType {
	switch depth {
	case .none:
		return (offset: CGSize.zero, opacity: 0, radius: 0)
	case .depth1:
		return (offset: CGSize(width: 0, height: 1), opacity: 0.3, radius: 1)
	case .depth2:
		return (offset: CGSize(width: 0, height: 2), opacity: 0.3, radius: 2)
	case .depth3:
		return (offset: CGSize(width: 0, height: 3), opacity: 0.3, radius: 3)
	case .depth4:
		return (offset: CGSize(width: 0, height: 4), opacity: 0.3, radius: 4)
	case .depth5:
		return (offset: CGSize(width: 0, height: 5), opacity: 0.3, radius: 5)
	}
}
