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
import flash.events.Event;
import pony.time.DeltaTime;

/**
 * ProgressBar
 * @author AxGord <axgord@gmail.com>
 */
class ProgressBar extends MovieClip implements Dynamic<MovieClip> {
#if !starling
	@:isVar public var auto(default, set):Void->Float;
	
	//@:extern private var bar:MovieClip;
	private var total:Float;
	
	@:isVar public var value(default, set):Float;
	
	public function new() {
		super();
		DeltaTime.fixedUpdate.once(init, -1);
	}
	
	private function init():Void {
		total = this.bar.width;
		this.bar.width = 0;
	}
	
	inline public function resolve(name:String):MovieClip return untyped this[name];
	
	public function set_value(v:Float):Float {
		this.bar.width = total * v;
		return value = v;
	}
	
	private function set_auto(f:Void->Float):Void->Float {
		if (auto == f) return f;
		if (f == null) {
			DeltaTime.fixedUpdate.remove(autoUpdate);
		} else
			DeltaTime.fixedUpdate.add(autoUpdate);
		return auto = f;
	}
	
	private function autoUpdate():Void {
		value = auto();
	}
#end
}