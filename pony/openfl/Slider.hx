/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.openfl;

import openfl.display.Bitmap;
import openfl.display.Sprite;
import pony.openfl.Button;
import pony.ui.gui.SliderCore;
import pony.ui.gui.ButtonCore;

private typedef SliderType = {
  public function new(?button:ButtonCore, size:Float, ?isVertical:Bool, ?invert:Bool, ?draggable:Bool):Void;
	dynamic public function changeX(v:Float):Void;
	dynamic public function changeY(v:Float):Void;
	public function endInit():Void;
}
/**
 * Slider
 * @author AxGord <axgord@gmail.com>
 */
@:generic
class Slider<T:SliderType> extends Sprite {

	public var core(default, null):T;
	
	public function new(b:Button, bg:Bitmap, invert:Bool=false, sizeFix:Float=0, bFix:Float=0, draggable:Bool=true) {
		super();
		addChild(bg);
		addChild(b);
		var isVert = bg.height > bg.width;
		core = new T(b.core, (isVert ? bg.height : bg.width) + sizeFix, isVert, invert, draggable);
		core.changeX = function(v:Float) b.x = Std.int(v + bFix); 
		core.changeY = function(v:Float) b.y = Std.int(v + bFix); 
		core.endInit();
	}
	
}