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
package pony.flash.ui;
import flash.display.MovieClip;
import flash.geom.Point;
import pony.time.DeltaTime;
import pony.ui.touch.Touch;
import pony.ui.touch.Touchable;

/**
 * TurningFree
 * @author AxGord <axgord@gmail.com>
 */
class TurningFree extends Turning {
#if !starling
	@:stage public var button:Button;
	@:stage public var lmin:MovieClip;
	@:stage public var lmax:MovieClip;
	private var _zero:Point = new Point(0, 0);
	
	public function new() {
		super();
		DeltaTime.fixedUpdate.once(init, -1);
	}
	
	private function init():Void {
		if (lmin != null) core.minAngle = lmin.rotation;
		if (lmax != null) core.maxAngle = lmax.rotation;
		core.currentAngle = handle.rotation;
		handle.mouseEnabled = false;
		var t = new Touchable(this);
		t.onDown << downHandler;
	}
	
	private function downHandler(t:Touch):Void {
		t.onMove << moveHandler;
	}
	
	private function moveHandler(t:Touch):Void {
		core.toPoint(new Point(t.x, t.y));
	}
#end
}