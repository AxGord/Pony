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
package pony.ui.touch;

import pony.events.Signal1;
import pony.magic.HasSignal;
import pony.geom.Point;

/**
 * Touch
 * @author AxGord <axgord@gmail.com>
 */
class Touch implements HasSignal {

	@:auto public var onOver:Signal1<Touch>;
	@:auto public var onOut:Signal1<Touch>;
	@:auto public var onOutUp:Signal1<Touch>;
	@:auto public var onOverDown:Signal1<Touch>;
	@:auto public var onOutDown:Signal1<Touch>;
	@:auto public var onDown:Signal1<Touch>;
	@:auto public var onUp:Signal1<Touch>;
	@:auto public var onMove:Signal1<Touch>;
	
	public var x(default, null):Float;
	public var y(default, null):Float;
	public var point(get, never):Point<Float>;
	
	public function new() {}
	
	public function clear():Void {
		onOver.clear();
		onOut.clear();
		onOutUp.clear();
		onOverDown.clear();
		onOutDown.clear();
		onDown.clear();
		onUp.clear();
		onMove.clear();
	}
	
	@:extern inline private function set(x:Float, y:Float):Touch {
		this.x = x;
		this.y = y;
		return this;
	}
	
	@:extern inline private function get_point():Point<Float> return new Point<Float>(x, y);
	
}