/**
* Copyright (c) 2012-2018 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
* 1. Redistributions of source code must retain the above copyright notice, this list of
*   conditions and the following disclaimer.
* 
* 2. Redistributions in binary form must reproduce the above copyright notice, this list
*   of conditions and the following disclaimer in the documentation and/or other materials
*   provided with the distribution.
* 
* THIS SOFTWARE IS PROVIDED BY ALEXANDER GORDEYKO ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ALEXANDER GORDEYKO OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/
package pony.ui.gui;

import pony.time.Time;
import pony.math.MathTools;

@:enum abstract AnimSmoothMode(Int) to Int from Int {
	
	var None = 1;
	var Simple = 2;
	var Super = 3;

	@:from public static function fromString(s:String):AnimSmoothMode {
		return if (s == null)
			None;
		else switch StringTools.trim(s).toLowerCase() {
			case 'simple': Simple;
			case 'super': Super;
			case _: None;
		}
	}

}

class AnimTextureCore extends AnimCore {

	private var smooth:AnimSmoothMode;
	private var additionalSrc:UInt;

	public function new(frameTime:Time, fixedTime:Bool = false, smooth:AnimSmoothMode = AnimSmoothMode.None, additionalSrc:UInt = 0) {
		if (additionalSrc > 1) throw 'Not supported';
		super(frameTime, fixedTime);
		this.smooth = smooth;
		this.additionalSrc = additionalSrc;
		if (additionalSrc == 1) switch smooth {
			case AnimSmoothMode.None: onFrame << frameNoneOddHandler;
			case AnimSmoothMode.Simple: onFrame << frameSimpleOddHandler;
			case AnimSmoothMode.Super: onFrame << frameSuperOddHandler;
		} else switch smooth {
			case AnimSmoothMode.None: onFrame << frameNoneHandler;
			case AnimSmoothMode.Simple: onFrame << frameSimpleHandler;
			case AnimSmoothMode.Super: onFrame << frameSuperHandler;
		}
	}

	private function frameNoneHandler(n:Int):Void {
		setTexture(0, n);
	}

	private function frameNoneOddHandler(n:Int):Void {
		setTexture(n % 2, n);
	}

	private function frameSimpleHandler(n:Int):Void {
		setTexture(n % 2, n);
		setTexture(1 - n % 2, n == totalFrames - 1 ? 0 : n + 1);
	}

	private function frameSimpleOddHandler(n:Int):Void {
		var map:Map<Int, Int> = MathTools.clipSmoothOddSimple(n, totalFrames);
		for (k in map.keys()) setTexture(k, map[k]);
	}

	private function frameSuperHandler(n:Int):Void {
		var map:Map<Int, Int> = MathTools.clipSmooth(n, totalFrames);
		for (k in map.keys()) setTexture(k, map[k]);
	}

	private function frameSuperOddHandler(n:Int):Void {
		var map:Map<Int, Int> = MathTools.clipSmoothOdd(n, totalFrames);
		for (k in map.keys()) setTexture(k, map[k]);
	}

	@:abstract private function setTexture(n:Int, f:Int):Void;

	override private function get_totalFrames():Int return throw 'abstract';
	
}