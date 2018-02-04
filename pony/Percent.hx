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
package pony;

class Percent implements pony.magic.HasSignal {

	@:bindable public var percent:Float;
	@:bindable public var full:Bool;
	@:bindable public var run:Bool;
	public var min(default, set):Float = 0;
	public var max(default, set):Float = -1;
	public var allow(default, set):Float = 1;

	public function new(allow:Float = 1, max:Float = -1) {
		this.allow = allow;
		this.max = max;
	}
	
	@:extern private inline function set_min(v:Float):Float {
		if (min != v) {
			min = v;
			updatePercent();
		}
		return v;
	}

	@:extern private inline function set_max(v:Float):Float {
		if (max != v) {
			max = v;
			updatePercent();
		}
		return v;
	}

	@:extern private inline function set_allow(v:Float):Float {
		if (allow != v) {
			allow = v;
			updatePercent();
		}
		return v;
	}

	@:extern private inline function updatePercent():Void {
		if (max == -1) {
			percent = 0;
			full = false;
			run = false;
		} else {
			percent = min / max;
			full = percent >= 1;
			run = percent >= allow;
		}
	}

}